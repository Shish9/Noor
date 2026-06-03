import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../data/reciter_data.dart';
import '../data/surah_data.dart';
import '../models/reciter.dart';
import '../models/surah.dart';
import '../services/storage_service.dart';

/// Per-ayah Quran audio player.
///
/// Architecture:
/// - Each ayah is its own audio file from everyayah.com.
/// - Tapping play on a specific ayah loads THAT ayah's file → user hears
///   exactly the verse they tapped (no more "always restart from ayah 1").
/// - When one ayah completes, we auto-advance to the next ayah of the same
///   surah and keep playing until the surah ends.
/// - `togglePlay()` pauses/resumes the loaded source without reloading, so
///   the pause button always works.
class AudioState extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  int? _currentSurahNumber;
  int? get currentSurahNumber => _currentSurahNumber;

  int? _currentAyahNumber;
  int? get currentAyahNumber => _currentAyahNumber;

  Reciter _reciter = ReciterData.all.first;
  Reciter get reciter => _reciter;

  Duration _position = Duration.zero;
  Duration get position => _position;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double _speed = 1.0;
  double get speed => _speed;

  Duration? _sleepTimer;
  Duration? get sleepTimer => _sleepTimer;
  DateTime? _sleepEnd;

  /// When true, finishing one ayah triggers the next ayah of the same surah.
  bool _autoAdvance = true;
  bool get autoAdvance => _autoAdvance;
  set autoAdvance(bool v) {
    _autoAdvance = v;
    notifyListeners();
  }

  AudioState() {
    _player.playerStateStream.listen((PlayerState state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      // Auto-advance: when the current ayah file finishes, play the next.
      if (state.processingState == ProcessingState.completed &&
          _autoAdvance &&
          _currentSurahNumber != null &&
          _currentAyahNumber != null) {
        final int next = _currentAyahNumber! + 1;
        final int max = SurahData.byNumber(_currentSurahNumber!).ayahCount;
        if (next <= max) {
          // ignore: discarded_futures
          playAyah(_currentSurahNumber!, next);
        } else {
          // Surah finished.
          _currentAyahNumber = null;
        }
      }
      notifyListeners();
    });
    _player.positionStream.listen((Duration p) {
      _position = p;
      if (_sleepEnd != null && DateTime.now().isAfter(_sleepEnd!)) {
        _player.pause();
        _sleepTimer = null;
        _sleepEnd = null;
      }
      notifyListeners();
    });
    _player.durationStream.listen((Duration? d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });
  }

  /// Returns true if THIS specific ayah is the current loaded source.
  bool isCurrentAyah(int surahNumber, int ayahNumber) =>
      _currentSurahNumber == surahNumber && _currentAyahNumber == ayahNumber;

  /// Returns true if any ayah of this surah is currently loaded.
  bool isCurrentSurah(int surahNumber) => _currentSurahNumber == surahNumber;

  /// Plays a specific ayah of a specific surah. This is the primary
  /// entry point — every per-ayah play action in the UI calls this.
  Future<void> playAyah(
    int surahNumber,
    int ayahNumber, {
    Reciter? reciter,
  }) async {
    final Reciter use = reciter ?? _reciter;
    _reciter = use;
    _currentSurahNumber = surahNumber;
    _currentAyahNumber = ayahNumber;
    _isLoading = true;
    notifyListeners();

    try {
      final Surah surah = SurahData.byNumber(surahNumber);
      // A MediaItem tag is required by just_audio_background and powers the
      // lock-screen / notification controls (surah name + reciter).
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(use.ayahUrl(surahNumber, ayahNumber)),
          tag: MediaItem(
            id: '$surahNumber:$ayahNumber:${use.id}',
            album: use.name,
            title: '${surah.nameArabic} · ${surah.nameTransliteration}',
            artist: 'Ayah $ayahNumber',
          ),
        ),
      );
      await _player.setSpeed(_speed);
      await _player.play();
      await StorageService.instance.addRecentlyPlayed(
        surahNumber: surahNumber,
        reciterId: use.id,
      );
    } catch (_) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// "Play whole surah" = start from ayah 1; auto-advance will take it
  /// through to the end.
  Future<void> playSurah(int surahNumber, {Reciter? reciter}) =>
      playAyah(surahNumber, 1, reciter: reciter);

  /// Smart toggle for a per-ayah play button:
  /// - If this exact ayah is loaded → pause/resume in place
  /// - If any other ayah is loaded → switch to this ayah
  Future<void> toggleAyah(int surahNumber, int ayahNumber) async {
    if (isCurrentAyah(surahNumber, ayahNumber)) {
      await togglePlay();
    } else {
      await playAyah(surahNumber, ayahNumber);
    }
  }

  /// Pause/resume the currently-loaded source. Does NOT reload, so the
  /// position is preserved.
  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration p) => _player.seek(p);

  Future<void> setSpeed(double s) async {
    _speed = s;
    await _player.setSpeed(s);
    notifyListeners();
  }

  Future<void> setReciter(Reciter r) async {
    _reciter = r;
    if (_currentSurahNumber != null && _currentAyahNumber != null) {
      await playAyah(_currentSurahNumber!, _currentAyahNumber!, reciter: r);
    }
    notifyListeners();
  }

  void setSleepTimer(Duration? d) {
    _sleepTimer = d;
    _sleepEnd = d == null ? null : DateTime.now().add(d);
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentSurahNumber = null;
    _currentAyahNumber = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
