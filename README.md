# Syntrophe - Bible Study Partner App

A premium offline-first Android Bible study companion built with Flutter.

## Features

- **Bible Text**: Verse-by-verse reading with offline caching
- **Notes**: Rich-text markdown notes with scripture reference linking
- **Transcription**: On-device speech-to-text for voice notes
- **Sermons**: Video/audio playback with Picture-in-Picture support
- **Alarms**: Gentle chime alarms for study reminders

## Tech Stack

- **Framework**: Flutter 3.24+
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Local Cache**: Hive
- **Video/Audio**: video_player, chewie, just_audio
- **Speech-to-Text**: speech_to_text
- **Notifications**: flutter_local_notifications

## Project Structure

```
lib/
├── core/                    # Core utilities, theme, constants
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/                    # Data layer
│   ├── database/
│   ├── repositories/
│   └── sources/
├── domain/                  # Domain layer
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/            # UI layer
    ├── providers/
    ├── screens/
    └── widgets/
```

## Getting Started

### Prerequisites

- Flutter SDK 3.24+
- Java 17
- Android Studio / VS Code

### Installation

1. Clone the repository
2. Run `flutter pub get`
3. Generate code: `flutter pub run build_runner build`
4. Run `flutter run`

## Debug Builds via GitHub Actions

This project includes a GitHub Actions workflow that automatically builds debug APK and AAB files:

- Triggered on push to `main` branch or manual dispatch
- Outputs are uploaded as GitHub Artifacts
- No signing configuration required for debug builds

## Theme

The app features a serene, premium design with:
- Light mode: Warm cream background with terracotta accents
- Dark mode: Deep navy background with coral accents
- Smooth 300ms crossfade transitions
- Glassmorphic bottom sheets
- Shimmer skeleton loaders

## License

MIT License
