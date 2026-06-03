# Noor — Launch Guide

This is the step-by-step to take Noor from "working in dev" to "live on the
stores". Items marked ✅ are already done in the repo; ⬜ are on you.

---

## Current status

✅ App code complete (Quran, Du'as, Dhikr, Prayer + Qibla, Share, onboarding,
   notifications, EN/AR with full RTL)
✅ App icon generated + wired for Android (all densities + adaptive icon)
✅ `flutter analyze` — 0 errors
✅ Gradle 8.7 + AGP 8.3 (Java 21 compatible)
✅ Android SDK located + licenses accepted
✅ Privacy policy drafted (`PRIVACY_POLICY.md`)
✅ Release signing config ready (`android/app/build.gradle` reads `key.properties`)

⬜ Install the Android NDK (one-time, needs admin — see below)
⬜ Generate a release keystore
⬜ Test on a real device
⬜ iOS icon + build (needs a Mac)
⬜ Store accounts + listings

---

## STEP 1 — Finish the local build (Android NDK)

The build is blocked by one thing: a plugin requires **NDK 25.1.8937393**, and
your Android SDK lives in `C:\Program Files (x86)\Android\android-sdk`, which
Windows won't let a normal process write to. Pick ONE fix:

### Option A — Install the NDK as Administrator (fastest)
1. Press Start, type **cmd**, right-click **Command Prompt → Run as administrator**.
2. Run:
   ```
   "C:\Program Files (x86)\Android\android-sdk\cmdline-tools\12.0\bin\sdkmanager.bat" --install "ndk;25.1.8937393"
   ```
   Press `y` to accept the license.

### Option B — Open the project in Android Studio (handles it for you)
1. Open Android Studio → Open → select `E:\QuranApp\android`.
2. It will prompt to install the missing NDK — click **Install**.

### Option C — Move the SDK somewhere writable
1. Copy `C:\Program Files (x86)\Android\android-sdk` to `C:\Users\amedd\Android\Sdk`.
2. Run: `flutter config --android-sdk "C:\Users\amedd\Android\Sdk"`.
3. Then `flutter doctor --android-licenses` (accept all).

Then build:
```
flutter build apk --release
```
Output: `build\app\outputs\flutter-apk\app-release.apk` — copy this to your
phone and install it (enable "Install unknown apps" for your file manager).

---

## STEP 2 — Test on a real phone (no account needed)

Install the APK from Step 1 and verify the things web preview can't show:
- [ ] Location permission prompt → prayer times update for your city
- [ ] Qibla compass responds to turning the phone
- [ ] Quran audio plays a single ayah, pauses, auto-advances
- [ ] Audio keeps playing when you background the app / lock the screen
- [ ] Hourly du'a notification appears
- [ ] Share a story card → it lands in your gallery
- [ ] Arabic ⇄ English flips the whole layout

Fix anything that misbehaves before going to the stores.

---

## STEP 3 — Release keystore (one-time)

```
keytool -genkey -v -keystore noor-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias noor
```
Keep `noor-release.jks` somewhere safe and **back it up** — losing it means you
can never update the app on Play again.

Then create `android/app/key.properties` (already git-ignored):
```
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=noor
storeFile=C:/absolute/path/to/noor-release.jks
```

Build the upload bundle:
```
flutter build appbundle --release
```
Output: `build\app\outputs\bundle\release\app-release.aab`

---

## STEP 4 — Google Play (Android)

1. Create a **Google Play Console** account — https://play.google.com/console
   ($25 one-time).
2. Create app → fill in name (**Noor**), language, category (**Books & Reference**).
3. Upload the `.aab` from Step 3 to **Production → Create release**.
4. Complete: store listing (use `README.md`), screenshots (capture from your
   phone), content rating questionnaire, **privacy policy URL** (host
   `PRIVACY_POLICY.md` — e.g. a GitHub Pages link or Google Site), and the
   Data Safety form (declare: location used on-device, no data shared).
5. Submit. Review is usually a few hours to a couple days.

---

## STEP 5 — App Store (iOS) — needs a Mac

1. On a Mac with Xcode: `flutter create . --platforms=ios` (scaffolds the
   Xcode project), then flip `ios: true` in the `flutter_launcher_icons:`
   block of `pubspec.yaml` and run `dart run flutter_launcher_icons`.
2. Open `ios/Runner.xcworkspace`, set Bundle ID `app.noor`, select your team.
3. `flutter build ipa --release`.
4. Create an **Apple Developer** account ($99/yr) + an app record in
   **App Store Connect**.
5. Upload the `.ipa` via Transporter or Xcode, fill the listing + privacy
   answers, submit. Review is ~1-3 days.

---

## Store listing copy (ready to paste)

**Name:** Noor
**Subtitle / short:** Quran · Du'as · Dhikr · Prayer times
**Category:** Books & Reference (primary), Lifestyle (secondary)
**Languages:** English, Arabic
**Description:** see `README.md`.
**Privacy policy:** `PRIVACY_POLICY.md` (host it and use the URL).
