# 2048 Puzzle

A Flutter implementation of the classic 2048 sliding-tile puzzle game, built for Android (with web support).

## Gameplay

Swipe in any direction to slide all tiles. When two tiles with the same number collide, they merge into one. Reach the **2048** tile to win — or keep going for a higher score!

## Features

- 4×4 grid with smooth swipe controls
- Persistent high score across sessions (`shared_preferences`)
- Dark / Light theme toggle
- Win overlay with "Keep Going" option
- Game statistics: moves and merges per session
- **Privacy Policy** screen (in-app)
- **Terms of Service** screen (in-app)
- **About** screen with how-to-play guide
- Side drawer navigation to all screens

## Screens

| Screen | Route |
|--------|-------|
| Game | `/` |
| Privacy Policy | `/privacy` |
| Terms of Service | `/terms` |
| About | `/about` |

## Project Structure

```
lib/
├── main.dart                      # App entry, MyApp, Game2048 widget
└── screens/
    ├── privacy_policy_page.dart   # Privacy Policy
    ├── terms_of_service_page.dart # Terms of Service
    └── about_page.dart            # About & How to Play
```

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Android SDK (for Android builds)

### Run

```bash
flutter pub get
flutter run
```

### Build for Android

```bash
# Debug APK
flutter build apk --debug

# Release APK (requires signing config)
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

### Build for Web (GitHub Pages / Firebase)

```bash
flutter build web --release
```

## Android Store Readiness

- **Application ID**: `com.game2048.puzzle`
- **Min SDK**: 21 (Android 5.0)
- **Version**: 1.0.0 (build 1)
- **Permissions**: None required
- **Privacy Policy**: Included in-app at `/privacy`

> **Note**: Before publishing to the Play Store, replace the debug signing config in `android/app/build.gradle.kts` with your own release keystore.

## Credits

The 2048 concept was originally created by [Gabriele Cirulli](https://github.com/gabrielecirulli/2048) under the MIT License.
