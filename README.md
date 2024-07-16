# chat-application
A chat application built using Flutter and Dart with Firebase for backend services. The app features phone authentication, real-time chatting, and video call functionality using Agora.
<br>
# Features
Phone Authentication:  Users can register and log in using their phone number and OTP.
<br>

Real-Time Chatting:  Utilizes Firebase Realtime Database to handle messages.<br>

Message Sorting:  Messages are sorted according to time, and the last message and time are displayed on the friend list screen.<br>

Message Segregation:  Messages are separated by day for better readability.<br>

Video Calls: Integrated with Agora for video calling functionality.<br>
<br>
# Tech Stack
Flutter: The main framework for building the app.

Dart: Programming language used for Flutter development.
# Firebase:
Authentication: For phone number authentication.

Realtime Database: For real-time messaging.

Providers: For state management.

Agora: For video call functionality.

Visual Studio Code: Recommended IDE for development.

# Prerequisites
Flutter SDK: Installation Guide

Dart SDK: Bundled with Flutter SDK

Firebase Account: Firebase Console

Agora Account: Agora Console

# Installation
Clone the Repository:
git clone https://github.com/your-username/chat-application.git
cd chat-application

# Install Dependencies:
flutter pub get

# Set Up Firebase:
Create a Firebase project in the Firebase Console.
Add an Android/iOS app to your Firebase project.
Download the google-services.json (for Android) and/or GoogleService-Info.plist (for iOS) files.

Place these files in the respective directories:android/app/ for google-services.json ios/Runner/ for GoogleService-Info.plist
Enable Firebase Authentication with Phone Sign-In in your Firebase project.
Enable Firebase Realtime Database in your Firebase project.

# Set Up Agora:

Create a project in the Agora Console.
Obtain an App ID from the Agora Console.
Replace the placeholder your-agora-app-id in your project with the actual App ID.
Configuration
Firebase Configuration:
Ensure you have configured your Firebase project correctly and added the necessary files to your Flutter project.

# Agora Configuration:

Open your project and locate the agora.dart file or wherever you have the Agora integration. Replace the placeholder with your Agora App ID:

const APP_ID = 'your-agora-app-id';

# License
This project is licensed under the MIT License - see the LICENSE file for details.

# Acknowledgements
Flutter<br>
Firebase<br>
Agora<br>
Provider Package<br>
