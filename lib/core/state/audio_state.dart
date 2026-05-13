import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../data/reciter_data.dart';
import '../models/reciter.dart';
import '../services/storage_service.dart';

class AudioState extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  int? _currentSurahNumber;
  int? get currentSurahNumber => _currentSurahNumber;

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

  AudioState() {
    _player.playerStateStream.listen((PlayerState state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
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

  Future<void> playSurah(int surahNumber, {Reciter? reciter}) async {
    final Reciter use = reciter ?? _reciter;
    _reciter = use;
    _currentSurahNumber = surahNumber;
    _isLoading = true;
    notifyListeners();

    try {
      // Plain URL set — `just_audio_background` (initialized in main.dart on
      // mobile only) handles lock-screen + notification controls via the
      // shared player instance, no per-source MediaItem needed for the
      // background pipeline to work.
      await _player.setUrl(use.surahUrl(surahNumber));
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
    if (_currentSurahNumber != null) {
      await playSurah(_currentSurahNumber!, reciter: r);
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
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
