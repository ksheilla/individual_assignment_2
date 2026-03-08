# Kigali City Services & Places Directory

A comprehensive Flutter mobile application for browsing, creating, and managing essential public services and leisure locations in Kigali, Rwanda.

## Features

- **User Authentication**
  - Email and password sign-up
  - Email verification
  - Secure login and logout
  - User profile management

- **Location Listings (CRUD)**
  - Create new service/location listings
  - Read and browse all listings
  - Update your own listings
  - Delete your listings
  - Real-time updates via Firebase Firestore

- **Search & Filtering**
  - Search listings by name
  - Filter by category (Hospital, Police Station, Restaurant, Café, etc.)
  - Dynamic filtering with real-time results

- **Map Integration**
  - View listings on Google Maps
  - Get directions to locations
  - Display location details with coordinates

- **Bookmarking**
  - Save favorite listings
  - Access bookmarks from dedicated screen
  - Quick access to saved locations

- **User Interface**
  - Bottom navigation bar with 5 main screens
  - Directory (Browse all listings)
  - My Listings (User-created listings)
  - Bookmarks (Saved listings)
  - Map View (All locations on map)
  - Settings (Profile & preferences)

- **Settings & Preferences**
  - View and manage profile information
  - Toggle location-based notifications
  - Email verification status

## Project Structure

```
lib/
├── models/
│   ├── user_model.dart
│   └── listing_model.dart
├── services/
│   ├── auth_service.dart           # Firebase Auth operations
│   ├── firestore_service.dart      # Firestore CRUD operations
│   └── location_service.dart       # Geolocation services
├── providers/
│   ├── auth_provider.dart          # Authentication state management
│   └── listing_provider.dart       # Listings state management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── email_verification_screen.dart
│   ├── directory/
│   │   ├── directory_screen.dart
│   │   ├── listing_detail_screen.dart
│   │   ├── create_listing_screen.dart
│   │   └── edit_listing_screen.dart
│   ├── my_listings/
│   │   └── my_listings_screen.dart
│   ├── bookmarks/
│   │   └── bookmarks_screen.dart
│   ├── map/
│   │   └── map_view_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   └── home/
│       └── home_screen.dart
├── utils/
│   └── constants.dart
├── widgets/
├── firebase_options.dart
└── main.dart
```

## Setup Instructions

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Firebase project (create at https://firebase.google.com)
- Google Maps API key

### Step 1: Configure Firebase

1. Create a Firebase project in the Firebase Console
2. Enable the following Firebase services:
   - Authentication (Email/Password)
   - Cloud Firestore
3. Create a Firestore database in production mode (or test mode for development)
4. Initialize authentication with Email/Password provider

### Step 2: Set Up FlutterFire

Run the FlutterFire configuration command:

```bash
cd kigali_city_serviced
flutterfire configure
```

This command will:
- Prompt you to select your Firebase project
- Generate `firebase_options.dart` with your project configuration
- Update Android and iOS project files with Firebase configurations

### Step 3: Configure Google Maps

1. Get your Google Maps API key from Google Cloud Console
2. Add to your Firebase project configuration
3. For Android:
   - Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```
4. For iOS:
   - Add to `ios/Runner/GeneratedPluginRegistrant.m` and configure in AppDelegate.swift

### Step 4: Install Dependencies

```bash
flutter pub get
```

### Step 5: Run the Application

```bash
flutter run
```

## Firestore Database Schema

### Users Collection

```json
{
  "uid": "user_id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "url_or_null",
  "emailVerified": false,
  "notificationsEnabled": true,
  "createdAt": "2024-03-03T10:00:00Z"
}
```

### Listings Collection

```json
{
  "id": "listing_id",
  "name": "Kigali Central Hospital",
  "category": "Hospital",
  "address": "123 Main Street, Kigali",
  "contactNumber": "+250788123456",
  "description": "Central hospital with emergency services",
  "latitude": -1.9536,
  "longitude": 30.0606,
  "createdBy": "user_uid",
  "createdAt": "2024-03-03T10:00:00Z",
  "bookmarkedBy": ["user_id_1", "user_id_2"]
}
```

## State Management

This application uses **Provider** for state management, ensuring:

- Clean separation between UI and business logic
- Real-time updates from Firestore
- Efficient widget rebuilding
- Easy testability

### Key Providers

- **AuthProvider**: Manages user authentication state and profile
- **ListingProvider**: Manages listings CRUD operations and filters

## Navigation

The application uses Material Design's BottomNavigationBar for navigation between screens:

1. **Directory**: Browse all available listings with search and filtering
2. **My Listings**: View and manage your own listings
3. **Bookmarks**: Access your saved favorite listings
4. **Map**: View all listings on an interactive map
5. **Settings**: Manage profile and user preferences

## Location Services

The app includes location services that:

- Request user permission for location access
- Get current device location
- Calculate distances between coordinates
- Default to Kigali city center if location is unavailable

## Search and Filtering

- **Search**: Filter listings by name (case-insensitive)
- **Category Filter**: Filter by predefined categories:
  - Hospital
  - Police Station
  - Library
  - Restaurant
  - Café
  - Park
  - Tourist Attraction
  - Pharmacy

Filters can be combined for precise results.

## Notifications

The app supports location-based notification preferences that can be toggled in Settings. (Current implementation is a local preference toggle)

## Error Handling

The application includes robust error handling:
- Firebase authentication errors
- Network connectivity issues
- Location permission denials
- Invalid form inputs
- Database operation failures

## Security Notes

1. Firebase Security Rules should be configured in Firestore console:
   - Only authenticated users can read/write
   - Users can only modify their own listings
   - All users can read a listing but only creator can edit/delete


