# Noor — نُور

A premium modern Islamic app for Quran reading, duas, and daily spiritual engagement. Built with Flutter, designed to feel like a quiet luxury meditation app for the soul.

## Design language

- **Matte black** base with warm undertone for depth
- **Emerald green** glow accents (primary brand)
- **Refined gold** details for divine highlights
- **Glassmorphism** cards with backdrop blur and soft borders
- **Living animated background** — drifting particles, ambient glow
- **Calligraphy-inspired** Arabic typography (Amiri, Scheherazade New)
- **Premium Latin** typography (Inter + Cormorant Garamond)
- Rounded corners everywhere · soft fade transitions · interactive glow buttons

## Features

| Area | Highlights |
| --- | --- |
| **Home** | Greeting · streak widget · continue reading · daily ayah · daily dua · prayer times · recently played · quotes |
| **Quran** | All 114 surahs · search & filter (Meccan/Medinan) · distraction-free reader · bookmarks · adjustable font · last-read auto-save · prev/next navigator |
| **Audio** | 6 reciters · full player with album-art glow · mini player above nav · sleep timer · playback speed · animated sound waves |
| **Duas** | 9 curated categories · authentic supplications with Arabic, transliteration, translation, reference · favorites · copy · share |
| **Notifications** | Hourly soft dua reminders · customizable interval (1/2/3/4/6/12h) · silent mode · rotating titles |
| **Share** | Beautiful 9:16 story cards · 6 themes (Minimal Black, Emerald Luxury, Gold, Nature, Mosque Silhouette, Soft Glow) · save to gallery · direct share to IG/TikTok |
| **Profile** | Stats · streaks · longest streak · saved bookmarks · settings |

## Architecture

```
lib/
├── main.dart                       Entry point — Hive, notifications, providers
├── app/
│   ├── app.dart                    MaterialApp + routing
│   └── router.dart                 Custom transitions
├── core/
│   ├── theme/                      Colors, typography, theme
│   ├── widgets/                    GlassCard, GlowButton, AnimatedBackground, ArabicPattern
│   ├── data/                       Surah metadata, dua catalog, reciter list
│   ├── models/                     Surah, Ayah, Dua, Reciter
│   ├── services/                   Storage (Hive), Notifications, Quran API, Audio
│   └── state/                      ChangeNotifier providers (App, Settings, Quran, Audio)
└── features/
    ├── onboarding/                 4-page intro
    ├── shell/                      Glass nav bar + persistent shell
    ├── home/                       Home + widgets
    ├── quran/                      List, reader, search
    ├── audio/                      Full player, mini player, reciters
    ├── duas/                       Categories, list, detail
    ├── profile/                    Profile + settings
    └── share/                      Story card + 6 themes (mosque, nature, gold, ...)
```

## Tech stack

- **Flutter 3.19+ / Dart 3.3+**
- **State**: provider
- **Storage**: hive, shared_preferences
- **Audio**: just_audio + audio_service (background playback)
- **Notifications**: flutter_local_notifications + timezone
- **HTTP**: dio (with on-disk caching)
- **UI**: google_fonts, flutter_animate, shimmer, glassmorphism
- **Sharing**: share_plus, screenshot, image_gallery_saver_plus
- **Quran API**: AlQuran.cloud (Uthmani text + Sahih translation)
- **Audio CDN**: mp3quran.net

## Getting started

```bash
# 1. Install Flutter SDK 3.19+
# 2. Drop the four font files into assets/fonts/ (see assets/fonts/README.md)
# 3. From the project root:
flutter pub get
flutter run
```

For Firebase backend integration (user accounts, cloud sync, OneSignal targeting), add `firebase_core` + `cloud_firestore` and configure `google-services.json` / `GoogleService-Info.plist`.

## What makes Noor feel premium

1. **One shared animated background** rendered behind every tab — never flickers, low GPU cost.
2. **Glass everywhere** — every card uses backdrop blur with subtle borders and emerald glow halos.
3. **Real motion** — `flutter_animate` orchestrates staggered fade/slide entrances on every screen.
4. **Arabic-first design** — calligraphy fonts at large sizes, RTL spacing, gold-foiled surah names.
5. **Distraction-free reader** — single tap collapses chrome and animations for deep focus.
6. **Story cards built for virality** — 9:16 export, 6 themes, mosque silhouette + crescent moon, nature glow, geometric Islamic pattern overlays.

## License

MIT. The Quran text and dua references are public-domain authentic sources.
