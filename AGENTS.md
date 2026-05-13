# Repository Guidelines

## Project Structure & Module Organization
This is a Flutter application following a **Clean Architecture** and **Repository Pattern** with **Provider** for state management.
- **`lib/core/`**: Contains cross-cutting concerns like `router/` (GoRouter configuration), `theme/` (AppThemes), and `utils/` (AppConfig).
- **`lib/datasources/`**: Remote API data sources (e.g., `ApiDataSource` using Dio).
- **`lib/repositories/`**: Domain-specific repository implementations that abstract data sources.
- **`lib/providers/`**: State management using `ChangeNotifier`. These are registered in `lib/main.dart` via `MultiProvider`.
- **`lib/screens/`**: UI layer organized by feature/view.
- **`lib/models/`**: Data models for serialization/deserialization.

## Build, Test, and Development Commands
The project uses **FVM** (Flutter Version Management) for version consistency.
- **Get dependencies**: `fvm flutter pub get`
- **Run the app**: `fvm flutter run`
- **Run all tests**: `fvm flutter test`
- **Analyze code**: `fvm flutter analyze`
- **Run a specific test**: `fvm flutter test test/widget_test.dart`

## Coding Style & Naming Conventions
- Enforced by `flutter_lints` as defined in `./analysis_options.yaml`.
- Standard Dart naming conventions: `camelCase` for variables/functions, `PascalCase` for classes, and `snake_case` for filenames.
- Prefer `const` constructors where possible to optimize performance.

## Testing Guidelines
- Testing framework: `flutter_test`.
- Test files reside in the `./test/` directory and should mirror the `./lib/` structure where applicable.
- Ensure all business logic in `repositories` and `providers` has corresponding unit tests.

## Commit & Pull Request Guidelines
- Commit messages are typically short and descriptive (e.g., "api data source code change", "provider files fix").
- Maintain lowercase or sentence-case descriptions for consistency with existing history.
