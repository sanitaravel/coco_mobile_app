# Copilot Instructions for coco_mobile_app

## Project Overview
- **Purpose**: Mobile app for ad agency COCO
- **Features**:
  - Dashboard with performance metrics for social networks
  - Guides for content creation
  - Tools for creating content (video filming/editing, blog post writing)

## Architecture
- **Framework**: Flutter mobile app targeting Android, iOS, Web, Windows, Linux, macOS
- **State Management**: Uses flutter_bloc (^9.1.1) for managing app state (implemented for navigation)
- **UI Framework**: Material Design (enabled in pubspec.yaml)
- **Entry Point**: `lib/main.dart` - app with bottom navigation bar and four pages using BLoC
- **Project Structure**: Standard Flutter layout with platform-specific folders (android/, ios/, etc.)

## Dependencies
- **Core**: flutter (SDK ^3.9.2)
- **State**: flutter_bloc (^9.1.1) - BLoC pattern implemented for navigation
- **Icons**: font_awesome_flutter (^10.12.0) - for FontAwesome icons (recently added)
- **Dev**: flutter_lints (^5.0.0) for code analysis

## Workflows
- **Run App**: `flutter run` (targets connected device/emulator)
- **Build Android APK**: `flutter build apk --release`
- **Build iOS**: `flutter build ios --release` (requires macOS)
- **Test**: `flutter test` (no tests implemented yet)
- **Lint**: `flutter analyze` (uses flutter_lints)
- **Upgrade**: `flutter upgrade` (recently run)
- **Add Packages**: `flutter pub add <package>` (e.g., font_awesome_flutter)

## Conventions
- **Linting**: Follows flutter_lints rules (analysis_options.yaml includes package:flutter_lints/flutter.yaml)
- **Code Style**: Standard Dart/Flutter conventions
- **Icons**: Use FontAwesome icons via font_awesome_flutter package
- **State**: Implement features using BLoC pattern with flutter_bloc
- **Commit Naming**: Use conventional commits format (e.g., `feat:` for new features, `fix:` for bug fixes, `docs:` for documentation updates, `refactor:` for code refactoring, `test:` for adding tests, `chore:` for maintenance tasks)

## Key Files
- `pubspec.yaml`: Dependencies and Flutter config
- `lib/main.dart`: App entry point and basic structure
- `analysis_options.yaml`: Linting configuration