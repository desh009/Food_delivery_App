# food_hjoiopk — Food Delivery App

A Flutter food delivery app with Firebase-backed auth/data, Google Maps location selection, and order tracking.

## Tech stack

- **Flutter** + **GetX** (state management, routing, dependency injection)
- **Firebase**: Auth, Cloud Firestore
- **Google Maps** (`google_maps_flutter`), **Geolocator**, **permission_handler**
- **flutter_screenutil** for responsive layouts
- Other: `intl_phone_field`, `image_picker`, `shared_preferences`, `email_otp`, `carousel_slider`

## Prerequisites

- Flutter SDK **3.44.8** or newer (Dart SDK `^3.12.2`) — check with `flutter --version`, upgrade with `flutter upgrade` if needed
- Android Studio (Android builds) and/or Xcode (iOS builds)
- A connected device or emulator — list available targets with `flutter devices`

## Getting started

1. Clone the repo and install dependencies:
   ```bash
   git clone <repo-url>
   cd Food_delivery_App
   flutter pub get
   ```

2. **Firebase**: this repo already ships a configured Android Firebase setup (`android/app/google-services.json`, `firebase.json`, `lib/firebase_options.dart`) pointing at the project's own Firebase backend, so no extra setup is needed to run it as-is. To point the app at your **own** Firebase project instead, run:
   ```bash
   flutterfire configure
   ```

3. **Google Maps API key**: an API key is already set in `android/app/src/main/AndroidManifest.xml` under the `com.google.android.geo.API_KEY` meta-data entry. To use your own Google Cloud project's key (recommended for your own builds/production), replace the value there with a key that has the Maps SDK enabled.

4. Run the app:
   ```bash
   flutter run                # picks a connected device, or prompts you to choose
   flutter run -d chrome      # run in the browser
   flutter run -d <device-id> # run on a specific device (see `flutter devices`)
   ```

## Useful commands

- `flutter analyze` — static analysis
- `flutter pub outdated` — check for dependency updates
- `flutter build apk` / `flutter build ios` — production builds
