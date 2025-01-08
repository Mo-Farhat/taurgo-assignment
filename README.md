# RBAC CRUD App

A Flutter application with Firebase integration, following Role-Based Access Control (RBAC) principles and including CRUD operations.

## Prerequisites

- Flutter SDK (2.x or later)

- Dart SDK

- Firebase project set up

- Android Studio or Visual Studio Code

## Setup Instructions

1\. **Clone the Repository**  

   Clone the repository to your local machine:

   ```bash

   git clone <repository_url>

   cd <repository_name>

2\.  **Install Dependencies**

    Run the following command to install the necessary Flutter packages:

    `flutter pub get`

3\.  *Configure Environment Variables**

    Create a `.env` file in the root directory of the project with the following content:

    `FIREBASE_API_KEY=YOUR_FIREBASE_API_KEY

    FIREBASE_APP_ID=YOUR_FIREBASE_APP_ID

    FIREBASE_MESSAGING_SENDER_ID=YOUR_FIREBASE_MESSAGING_SENDER_ID

    FIREBASE_PROJECT_ID=YOUR_FIREBASE_PROJECT_ID

    FIREBASE_STORAGE_BUCKET=YOUR_FIREBASE_STORAGE_BUCKET`

    Replace the placeholders with your Firebase project details, which you can find in the Firebase Console.

4\. **Initialize Firebase**  

   Firebase configuration uses `flutter_dotenv` to load API keys from the `.env` file. Ensure `firebase_options.dart` accesses these variables correctly.

5\. **Run the App**  

   Use the following command to run the app:

   ```bash

   flutter run
