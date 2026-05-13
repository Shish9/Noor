# Flutter / Dart wrapper rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# just_audio + audio_service
-keep class com.ryanheise.** { *; }

# Hive
-keep class hive.** { *; }

# Local notifications
-keep class com.dexterous.** { *; }

# Required to keep generic signatures for Gson-style reflection
-keepattributes Signature
-keepattributes *Annotation*
