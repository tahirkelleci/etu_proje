# ETUBM 

<p align="center">
  <img src="assets/logo.png" alt="ETUBM Logo" width="200"/>
</p>

## 📱 Overview

ETUBM is a comprehensive mobile application designed for university students and staff. The app serves as a centralized platform for accessing university resources, staying updated on campus events, viewing announcements, and managing academic information - all in one place.

## ✨ Features

### 🔐 Authentication
- User registration and login
- Profile management with customizable profile pictures
- Secure password reset functionality
- Events and notifications management
  
### 📢 Campus Information
- **Events:** Browse, like, and participate in campus events
- **Announcements:** Stay updated with the latest university announcements
- **Ring Services:** Access campus shuttle information

### 🎓 Academic Tools
- **Course Schedule:** View your current semester schedule
- **Transcripts:** Access and view your academic records
- **UBYS Integration:** Connect to the university information system
- **Moodle Integration:** Access the learning management platform
- **Laboratory Information:** Find and access lab resources

### ⚙️ Personalization
- Dark/Light theme support
- Favorite and track events
- Personalized content based on user preferences

## 🛠️ Technologies Used

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase
  - Authentication
  - Cloud Firestore
  - Firebase Storage
- **State Management:** Provider
- **UI Components:** Material Design, Custom Widgets

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.6.0+)
- Dart (3.0.0+)
- Firebase account
- Android Studio / VS Code

### Getting Started

1. **Clone the repository**
   ```
   git clone https://github.com/yourusername/etubm.git
   cd etubm
   ```

2. **Install dependencies**
   ```
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Add Android & iOS apps to your Firebase project
   - Download and add the configuration files
   - Enable Authentication, Firestore, and Storage

4. **Run the application**
   ```
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── components/       # Reusable UI components
├── layouts/          # Layout templates and theme management
├── models/           # Data models
├── pages/            # App screens
├── firebase_service.dart    # Firebase integration
├── firebase_options.dart    # Firebase configuration
└── main.dart         # Entry point
```

## 🔥 Firebase Configuration

This application uses Firebase for backend services:

- **Authentication:** Email/Password authentication
- **Cloud Firestore:** NoSQL database for storing user data, events, and announcements
- **Storage:** For storing user profile images and event photos

Make sure to properly configure Firebase in your project by following the instructions in the [official Firebase documentation](https://firebase.google.com/docs/flutter/setup).
---

<p align="center">
  Made with ❤️ for university students
</p>
