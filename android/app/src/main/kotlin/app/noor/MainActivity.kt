package app.noor

import com.ryanheise.audioservice.AudioServiceActivity

// Must extend AudioServiceActivity (not FlutterActivity) so just_audio_background
// / audio_service can attach to the cached Flutter engine for lock-screen and
// background playback.
class MainActivity : AudioServiceActivity()
