# Picsum Gallery Flutter App

A premium Flutter application that fetches and displays beautiful images from the Picsum API using **Riverpod** for state management and **Dio** for networking.

## ✨ Features

- **Clean UI**: Modern, glassmorphism-inspired design with premium typography.
- **Sliver Architecture**: Smooth scrolling with a floating app bar.
- **Efficient Image Loading**: Uses `cached_network_image` for smooth performance and caching.
- **State Management**: Robust state handling with `flutter_riverpod`.
- **Error Handling**: Graceful error states and retry mechanisms.
- **Responsive**: Adapts to different screen sizes.

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Networking**: Dio
- **UI Components**: Shimmer, Google Fonts, Cached Network Image
- **Model Layer**: Equatable (for value comparison)

## 🚀 Getting Started

1. **Clone the repository** (after you push it to your GitHub):
   ```bash
   git clone <your-repo-link>
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── core/               # App-wide constants and themes
├── features/
│   └── gallery/        # Gallery feature module
│       ├── data/       # Models and Repositories
│       └── presentation/ # Providers, Screens, and Widgets
└── main.dart           # App entry point
```

## 📤 How to Upload to GitHub

If you haven't uploaded this project yet, follow these steps:

1. **Create a new repository** on GitHub (do not initialize with README).
2. **Open your terminal** in the project directory.
3. **Run the following commands**:
   ```bash
   git remote add origin https://github.com/AjhadK/<your-repo-name>.git
   git branch -M main
   git push -u origin main
   ```

Developed with ❤️ using Antigravity AI.
