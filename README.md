# Picsum Gallery - Production Flutter App

A production-ready Flutter application that fetches and displays high-quality images from the [Picsum API](https://picsum.photos/v2/list). Built with a focus on **Clean Architecture**, **Riverpod**, and **Premium UI/UX**.

## ✨ Key Features
- **Infinite Scrolling**: Automatically loads more images as you scroll using Riverpod's `AsyncNotifier`.
- **Advanced Search**: Real-time filtering by author name with a smooth UI transition.
- **Orientation Filtering**: Interactive filter chips to view only Landscape, Portrait, or Square images.
- **Sorting System**: Organize images by ID or Author Name via a premium Bottom Sheet.
- **Favorites System**: Save images locally using `shared_preferences` - data persists even after app restart!
- **Premium UX**: Includes Hero animations, Shimmer loading effects, and smooth haptic feedback.
- **Clean Architecture**: Decoupled layers (Domain, Data, Presentation) for maximum testability.

## 📸 Screenshots
*(Add screenshots here)*

## 🏗️ Architecture: Clean Architecture
This project follows **Clean Architecture** principles to ensure scalability, maintainability, and testability. The codebase is divided into three main layers:

### 1. Domain Layer (The Core)
Contains the business logic and rules. It is completely independent of other layers.
- **Entities**: Simple Dart classes representing the data (e.g., `ImageEntity`).
- **Repositories (Interfaces)**: Defines the contract for data operations.

### 2. Data Layer
Responsible for data retrieval from external sources (API, Database).
- **Models**: Extensions of entities with JSON serialization logic (`ImageModel`).
- **Repositories (Implementations)**: Concrete implementations of the domain repositories using `Dio`.

### 3. Presentation Layer
Contains everything related to the UI and state management.
- **Providers**: Riverpod providers managing the app state.
- **Screens**: Full pages (e.g., `GalleryScreen`).
- **Widgets**: Reusable UI components (e.g., `ImageCard`).

---

## 🚀 State Management: Riverpod
We use **Riverpod** for state management because:
- **Compile-time safety**: Catches errors early.
- **No BuildContext dependency**: Clean separation of logic and UI.
- **Testability**: Extremely easy to mock providers for unit testing.
- **Scalability**: Handles complex async states (Loading, Data, Error) natively via `AsyncValue`.

---

## 🛠️ Tech Stack
- **Networking**: `Dio` (Intercepts, BaseOptions, Error handling).
- **Image Handling**: `cached_network_image` for smooth performance and offline caching.
- **UI Architecture**: `CustomScrollView` with `SliverGrid` for a professional feel.
- **Theming**: Custom Material 3 theme with Google Fonts (Plus Jakarta Sans).

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK (Stable channel)
- Android Studio / VS Code
- Git

### Installation Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/AjhadK/picsum_gallery.git
   cd picsum_gallery
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📦 Building for Release

### Android
```bash
flutter build apk --release
# OR
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 📤 Git & GitHub Preparation

### Initialized Git
The project has been initialized with a standard Flutter `.gitignore`.

### Initial Commit
```bash
git add .
git commit -m "Initial commit - Flutter Picsum Gallery App"
```

### Pushing to GitHub
```bash
git remote add origin https://github.com/AjhadK/picsum_gallery.git
git branch -M main
git push -u origin main
```

---

Developed with ❤️ by **AjhadK** using **Antigravity AI**.
