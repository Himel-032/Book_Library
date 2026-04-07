# Book Library

A SwiftUI iOS application for discovering books, managing favorites, and tracking reading progress.

## Overview

Book Library combines three main capabilities:

- User authentication and profile management with Firebase Auth + Firestore
- Book discovery and search powered by the Google Books API
- Local reading state (favorites and finished status) persisted with Core Data

The app uses a clean MVVM-style structure with separate `Views`, `ViewModels`, `Services`, `Models`, and `Persistence` layers.

## Features

- Sign up, login, logout, and password reset
- Store and edit user profile data (name and country)
- Browse books by category
- Search books with debounced queries
- View detailed book information
- Open online preview/read links from Google Books
- Mark books as favorite
- Mark books as finished
- Favorites list with remove and clear-all support
- User-specific local storage (separate Core Data data per authenticated user)

## Tech Stack

- Swift + SwiftUI
- Firebase Authentication
- Cloud Firestore
- Google Books REST API
- Core Data
- Combine

## Project Structure

```text
BookLibrary/
  Home/                # Home screen and side menu
  Models/              # API/domain models (Book, User)
  Persistence/         # Core Data manager and local storage logic
  Profile/             # Profile edit flows
  Services/            # Network/auth services
  ViewModels/          # MVVM state and business logic
  Views/
	 Auth/              # Login, signup, reset password
	 Book/              # Book list, rows, details
	 Favorites/         # Favorites screens
```

## Requirements

- macOS with Xcode installed
- iOS deployment target supported by the project
- A Firebase project (Auth + Firestore enabled)
- Internet connection (for Google Books API calls)

## Getting Started

1. Clone the repository.
2. Open `BookLibrary.xcodeproj` in Xcode.
3. Add your Firebase configuration file:
	- Download `GoogleService-Info.plist` from Firebase Console.
	- Add it to the `BookLibrary` app target in Xcode.
4. Enable Firebase products in your Firebase project:
	- Authentication (Email/Password)
	- Firestore Database
5. Build and run on simulator or device.

## Configuration Notes

### Google Books API key

The API key is currently referenced in:

- `BookLibrary/Services/APIService.swift`

For production use, avoid hardcoding secrets directly in source code. Consider moving the key to a secure configuration strategy (for example, build settings, xcconfig files, or a backend proxy).

### Firestore user document

The app expects user documents in `users/{uid}` with fields:

- `uid`
- `email`
- `name`
- `country`
- `created_at`

## Data Model

Core Data entity: `BookEntity`

Persisted fields include:

- Book metadata (title, authors, description, publisher, etc.)
- `isFavorite`
- `isFinished`
- `dateAdded`
- `userId` (used to scope records per logged-in user)

## How the App Flows

1. App launches and configures Firebase.
2. If authenticated, user enters Home screen; otherwise Login screen is shown.
3. Home tab shows categorized book discovery and search.
4. Selecting a book opens details, with actions for favorite/finished and preview.
5. Favorites tab shows locally saved books.
6. Profile tab allows viewing and editing user details.

## Testing

The repository includes:

- `BookLibraryTests`
- `BookLibraryUITests`

Run tests in Xcode:

- Product -> Test



