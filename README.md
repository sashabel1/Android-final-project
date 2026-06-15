# Children Books App

A Flutter app for managing children’s books by age group and file type.
Users can register, log in, view default books, add demo books, choose an emoji for each book, download demo files, and delete only books they uploaded.

---

## Features

* Firebase Authentication: signup, login, logout
* Cloud Firestore for user data and books
* 6 categories:

  * PDF Ages 0–4
  * WORD Ages 0–4
  * PDF Ages 4–8
  * WORD Ages 4–8
  * PDF Ages 8–12
  * WORD Ages 8–12
* Default books are created automatically for each user
* Users can add books to a category
* Users can choose or type an emoji for each book
* Users can delete only books they uploaded
* Default books cannot be deleted
* Demo upload/download functionality

---

## Technologies

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Android Studio
* GitHub

---

## Installation and Run Instructions

### 1. Clone the project

```bash
git clone <REPOSITORY_URL>
cd children_books_app
```

Replace `<REPOSITORY_URL>` with the GitHub repository link.

---

### 2. Open in Android Studio

1. Open Android Studio.
2. Click:

```text
File → Open
```

3. Choose the project folder:

```text
children_books_app
```

4. Wait for Android Studio to finish loading the project.

---

### 3. Install dependencies

In the Android Studio terminal, run:

```bash
flutter pub get
```

---

### 4. Check Flutter setup

Run:

```bash
flutter doctor
```

Make sure there are no critical Flutter/Android errors.

---

### 5. Run the project on Chrome

Recommended for testing:

```bash
flutter run -d chrome
```

Or choose `Chrome (web)` from the device list in Android Studio and click the green Run button.

---

### 6. Run on Android Emulator

Open Android Studio:

```text
Tools → Device Manager
```

Start an emulator, then run:

```bash
flutter devices
flutter run -d android
```

---

## Firebase Setup

The project uses Firebase Authentication and Cloud Firestore.

In Firebase Console, make sure Email/Password login is enabled:

```text
Authentication → Sign-in method → Email/Password → Enable
```

Also make sure Cloud Firestore is created:

```text
Firestore Database → Create database
```

---

## Firestore Rules

Use these rules in:

```text
Firestore Database → Rules
```

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /books/{bookId} {
        allow read, create, update: if request.auth != null && request.auth.uid == userId;

        allow delete: if request.auth != null
          && request.auth.uid == userId
          && resource.data.isDefault == false;
      }
    }
  }
}
```

Click `Publish` after updating the rules.

---

## Firestore Data Structure

```text
users
  userId
    uid
    email
    name
    createdAt
    updatedAt

    books
      bookId
        ownerId
        title
        ageGroup
        format
        description
        emoji
        fileName
        isDefault
        createdAt
```

---

## Project Structure

```text
lib
  data
    demo_books.dart

  models
    book.dart

  screens
    auth_gate.dart
    books_screen.dart
    home_screen.dart
    login_screen.dart
    signup_screen.dart

  services
    auth_service.dart
    book_service.dart

  theme
    app_theme.dart

  widgets
    book_card.dart
    category_card.dart

  firebase_options.dart
  main.dart
```

---

## Notes

Upload and download are demo actions only.
The app saves book metadata in Firestore, but does not upload real files to Firebase Storage.

---

## Author

Developed by Sasha and Daniel.
