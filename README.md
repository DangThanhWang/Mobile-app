# 🦫 Triopybara - English Learning App

<div align="center">

![Triopybara Logo](assets/images/capylogo.png)

**A comprehensive English learning mobile application built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)](https://mongodb.com)

</div>

## 📚 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Overview

Triopybara is a comprehensive English learning mobile application designed to help users improve their English skills through interactive lessons, AI-powered conversations, pronunciation practice, and engaging activities. The app combines modern learning methodologies with cutting-edge technology to create an immersive learning experience.

### 🎯 Key Objectives

- **Interactive Learning**: Engaging vocabulary lessons with flashcards and quizzes
- **AI-Powered Assistance**: Fine-tuned chatbot for personalized learning support
- **Pronunciation Practice**: IPA-based pronunciation training with audio feedback
- **Social Learning**: Video calls and ranking system for competitive learning
- **Content Rich**: Reading materials, news, and stories for comprehension practice

## ✨ Features

### 🎓 Core Learning Features

- **📖 Vocabulary Learning**
    - Interactive flashcards with spaced repetition
    - Multiple choice quizzes
    - Definition guessing games
    - Categorized topics (Animals, Transportation, Family, Nature, etc.)

- **🔊 Pronunciation Training**
    - IPA (International Phonetic Alphabet) practice
    - Audio playback for correct pronunciation
    - Speech recognition for pronunciation assessment
    - Detailed mouth and tongue position guidance

- **🧠 Interactive Quizzes**
    - Grammar exercises
    - Vocabulary tests
    - Spelling challenges
    - Idioms and expressions

### 🤖 AI & Technology Features

- **💬 AI Chatbot**
    - Fine-tuned Qwen2-1.5B model for English learning
    - Context-aware conversations
    - Personalized learning recommendations
    - Multi-language support (Vietnamese & English)

- **📹 Video Calling**
    - Peer-to-peer language practice
    - WebRTC-based real-time communication
    - Automatic pairing with other learners

- **📱 Smart Dictionary**
    - Offline English-Vietnamese dictionary
    - Quick search with suggestions
    - Word definitions, examples, and synonyms
    - Floating dictionary for quick access

### 📊 Progress & Social Features

- **🏆 Ranking System**
    - Weekly and monthly leaderboards
    - Point-based progression
    - Achievement badges
    - Performance analytics

- **📰 Reading Materials**
    - Curated news articles
    - Short stories for different levels
    - Reading comprehension exercises
    - Bookmarking and progress tracking

### 👤 User Management

- **🔐 Authentication**
    - Firebase Authentication
    - Google Sign-In integration
    - Email/password registration
    - Profile management

- **⚙️ Personalization**
    - Custom learning paths
    - Progress tracking
    - Settings and preferences
    - Learning statistics

## 📱 Screenshots

*Screenshots will be added here showcasing the main features of the app*

## 🛠 Technology Stack

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: StatefulWidget with Provider pattern
- **UI Components**: Custom widgets with Material Design

### Backend & Services
- **Authentication**: Firebase Auth
- **Database**: MongoDB Atlas
- **File Storage**: Firebase Storage
- **Real-time Communication**: WebRTC for video calls

### AI & ML
- **Model**: Fine-tuned Qwen2-1.5B
- **Training**: LoRA (Low-Rank Adaptation)
- **Deployment**: FastAPI with Ngrok tunneling
- **Platform**: Google Colab GPU T4

### Audio & Media
- **Audio Processing**: audioplayers package
- **Speech Recognition**: speech_to_text
- **Text-to-Speech**: flutter_tts
- **Image Processing**: image_picker

## 🏗 Architecture

```
lib/
├── Components/          # Reusable UI components
│   ├── Footer/         # Bottom navigation
│   ├── Header/         # App headers
│   └── HomeTopButton.dart
├── Data/               # Static data and models
│   ├── Home/          # Home page data
│   ├── IPA/           # IPA pronunciation data
│   └── News/          # News and stories data
├── Database/          # Database configurations
│   └── mongoDB.dart
├── Definitons/        # App constants and configurations
├── helpers/           # Utility functions and helpers
├── Middlewares/       # Custom middleware components
├── Pages/             # Main application pages
│   ├── Auth/          # Authentication pages
│   ├── ChatBox/       # Chat functionality
│   ├── Home/          # Home and learning modules
│   ├── Pronunciation/ # Pronunciation practice
│   └── Profile/       # User profile management
├── Services/          # External API services
├── Widgets/           # Reusable widget components
└── main.dart          # Application entry point
```

## 🚀 Installation

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account
- MongoDB Atlas account

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/triopybara.git
   cd triopybara
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
    - Create a new Firebase project
    - Enable Authentication and Storage
    - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
    - Place them in the respective platform directories

4. **MongoDB Setup**
    - Create MongoDB Atlas account
    - Set up cluster and database
    - Update connection string in `lib/Definitons/Constants.dart`

5. **Run the application**
   ```bash
   flutter run
   ```

## ⚙️ Configuration

### Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project details:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-storage-bucket',
);
```

### MongoDB Configuration

Update `lib/Definitons/Constants.dart`:

```dart
const MONGO_URL = 'your-mongodb-connection-string';
```

### AI Chatbot Configuration

Update the chatbot API endpoint in `lib/Definitons/Constants.dart`:

```dart
const QWEN_MODEL_URL = 'your-ngrok-or-api-endpoint';
```

## 📖 Usage

### Getting Started

1. **Registration/Login**
    - Open the app and choose "Get Started"
    - Register with email/password or sign in with Google
    - Complete your profile setup

2. **Learning Path**
    - Select your current level (Beginner/Intermediate/Advanced)
    - Choose topics you want to focus on
    - Start with vocabulary flashcards or pronunciation practice

3. **AI Chatbot**
    - Access the chatbot from the bottom navigation
    - Ask questions about English grammar, vocabulary, or practice conversations
    - The AI provides personalized responses and learning recommendations

4. **Pronunciation Practice**
    - Navigate to the Pronunciation section
    - Select IPA sounds to practice
    - Listen to correct pronunciation and record yourself
    - Get instant feedback on your pronunciation accuracy

5. **Progress Tracking**
    - Check your ranking on the leaderboard
    - View detailed progress statistics
    - Earn points and badges for consistent learning

## 🔧 API Documentation

### Chatbot API

The app uses a custom fine-tuned Qwen2-1.5B model deployed via FastAPI:

**Endpoint**: `POST /chat`

**Request:**
```json
{
  "message": "Hello, how can I improve my English?",
  "user_id": "user123",
  "max_tokens": 200,
  "temperature": 0.7
}
```

**Response:**
```json
{
  "response": "Hello! Here are some effective ways to improve your English...",
  "generation_time": 2.3,
  "model_info": "Qwen2-1.5B Fine-tuned",
  "user_id": "user123",
  "status": "success"
}
```

### MongoDB Collections

- **Users**: User profiles and authentication data
- **Rooms**: Chat rooms and conversation history
- **Progress**: Learning progress and statistics

## 🤝 Contributing

We welcome contributions to Triopybara! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Guidelines

- Follow Flutter/Dart coding conventions
- Write meaningful commit messages
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation when necessary

## 🔍 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Manual Testing Checklist

- [ ] Authentication flows (register, login, logout)
- [ ] Vocabulary learning modules
- [ ] Pronunciation practice with audio
- [ ] Chatbot conversations
- [ ] Video calling functionality
- [ ] Progress tracking and rankings

## 🐛 Troubleshooting

### Common Issues

1. **Firebase Authentication Issues**
    - Verify SHA-1 fingerprints in Firebase Console
    - Check internet connectivity
    - Ensure Firebase configuration files are correctly placed

2. **MongoDB Connection Issues**
    - Verify connection string format
    - Check network whitelist in MongoDB Atlas
    - Ensure database permissions are correctly set

3. **Audio/Video Issues**
    - Grant microphone and camera permissions
    - Test on physical device (not emulator)
    - Check WebRTC compatibility

4. **AI Chatbot Not Responding**
    - Verify API endpoint is accessible
    - Check ngrok tunnel status
    - Ensure model is properly deployed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Quang** - Project Lead & Backend Development
- **Tai** - Flutter Development & UI/UX
- **Thanh** - AI/ML Integration & Testing

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Firebase](https://firebase.google.com) for backend services
- [MongoDB](https://mongodb.com) for database solutions
- [Qwen Team](https://github.com/QwenLM/Qwen) for the base AI model
- All contributors and beta testers

---

<div align="center">

**Made with ❤️ by the Triopybara Team**

[⬆ Back to Top](#-triopybara---english-learning-app)

</div>