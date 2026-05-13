# Publishing **Noor** to Google Play & App Store

Display name: **Noor** · Package id (Android): `app.noor` · Bundle id (iOS): set to `app.noor` in Xcode.

## ✅ Pre-flight checklist

```bash
flutter --version          # Flutter ≥ 3.19
flutter doctor             # all green ✓
flutter pub get            # dependencies resolved
flutter analyze            # no errors
flutter test               # smoke tests pass
```

## 🤖 Android — Google Play

### 1. Generate a release keystore (one-time)

```bash
keytool -genkey -v -keystore noor-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias noor
```

Move `noor-release.jks` somewhere safe **outside** the repo.

### 2. Wire signing

Copy the example file and fill in your real credentials:

```bash
cp android/app/key.properties.example android/app/key.properties
# Edit android/app/key.properties — point storeFile to the .jks you just created.
```

`key.properties` is in `.gitignore` — it must never be committed.

### 3. Build the App Bundle

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

Upload that `.aab` to **Google Play Console → Production → Create new release**.

### 4. Increment for future releases

In `pubspec.yaml`, bump `version: 1.0.0+1` → `1.0.1+2` (semver+buildNumber). Both halves drive Play Store comparison.

## 🍎 iOS — App Store

### 1. Bundle id + signing in Xcode

```bash
open ios/Runner.xcworkspace
```

In Xcode → **Runner target → Signing & Capabilities**:
- **Bundle Identifier**: `app.noor`
- **Team**: select your Apple Developer team
- ✓ **Automatically manage signing**
- (Optional) Capabilities → **Background Modes** → Audio (already declared in `Info.plist`)

### 2. Build the IPA

```bash
flutter build ipa --release
```

Output: `build/ios/ipa/noor.ipa`

### 3. Upload to App Store Connect

```bash
# Recommended: use Transporter.app (free on Mac App Store) and drag the .ipa
# OR via xcrun:
xcrun altool --upload-app -f build/ios/ipa/noor.ipa \
  -u YOUR_APPLE_ID -p YOUR_APP_SPECIFIC_PASSWORD
```

Then in **App Store Connect → My Apps → Noor → TestFlight / App Store** complete metadata, screenshots, submit for review.

### 4. App icons, screenshots

Replace the default icons under `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (use [appicon.co](https://appicon.co) to generate from a 1024×1024 source).

## 🌐 Web (optional)

```bash
flutter build web --release --base-href /
```

Deploy `build/web` to any static host (Netlify, Vercel, GitHub Pages, Firebase Hosting).

## 📱 Required permissions (already declared)

| Permission | Reason | Platform |
|---|---|---|
| Notifications | Hourly dua reminders | Android + iOS |
| Foreground service / Background audio | Quran recitation | Android + iOS |
| Photo library (write) | Save shared story cards | iOS |
| Storage / Media images | Save shared story cards | Android |
| Vibration | Subtle haptic feedback on dhikr | Android |
| Internet | Quran API + audio CDN | Android + iOS |
| Location (when in use, optional) | Accurate prayer times | Android + iOS |

## 🎨 App icon checklist

- [ ] Source: 1024×1024 PNG, transparent background
- [ ] Brand mark: gold "ن" on a matte black gradient with emerald glow
- [ ] Generate Android adaptive icon + iOS appiconset via [appicon.co](https://appicon.co)
- [ ] Drop into `android/app/src/main/res/mipmap-*` and `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## 📝 Store listing copy

**Subtitle (iOS, 30 chars):** `Quran · Duas · Dhikr`
**Short description (Play, 80 chars):** `Premium modern Islamic app for Quran reading, duas, and daily remembrance.`

**Long description:** see `README.md`.

**Languages declared in store listings:** English, Arabic, Kurdish (Sorani), Kurdish (Badini).
