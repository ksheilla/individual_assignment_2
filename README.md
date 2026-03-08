# Kigali City Services and Places Directory

A mobile application (Flutter based) to browse, create and manage key locations of public services and leisure in Kigali, Rwanda.

---

## Features

### User Authentication
- Email and password sign-up
- Email verification
- Secure login and logout
- User profile management

### Location Listings (CRUD)
- Add new service/location listing.
- Read and browse all listings
- Update your own listings
- Delete your listings
- Live time remedies through Firebase Firestore.

### Search & Filtering
- Search listings by name
- By category (Hospital, Police Station, Restaurant, Cafe, etc.)
- Real time results and dynamic filtering.

### Map Integration
- View listings on Google Maps
- Get directions to locations
- Show position of the display with co-ordinates.

### Bookmarking
- Save favorite listings
- Open bookmarks through special screen.
- Speedy access to visited places.

### User Interface
Bottom menu with 5 key screens:
- Publications (Browse all publication)
- My Listings (User created listings)
- Bookmarks (Saved listings)
- Map View (All locations on map)
- Tabs (Profile and preferences)

### Settings & Preferences
- Manage profile and view profile information.
- Switched location-based notifications.
- Email verification status

---

## Project Structure
```
lib/
+-- models/
    +-- usermodel.dart
    +-- listingmodel.dart
+-- services/
    +-- authservice.gap.dart    Firebase Auth operations in Gap.
    +-- firestoreservice.dart      # Firestore CAUD operations
    +-- locationservice.dart       # Geolocation services.
+-- providers/
    +-- authprovider.dart          # Authentication state management.
    +-- listingprovider.dart       # Listings state control.
+-- screens/
    +-- auth/
        +-- loginscreen.dart
        +-- signupscreen.dart
        +-- emailverificationscreen.dart
    +-- directory/
        +-- directoryscreen.dart
        +-- listingdetailscreen.dart
        +-- createlistingscreen.dart
        +-- editlistingscreen.dart
    +-- mylistings/
        +-- mylistingsscreen.dart
    +-- bookmarks/
        +-- bookmarksscreen.dart
    +-- map/
        +-- mapviewscreen.dart
    +-- settings/
        +-- settingsscreen.dart
    +-- home/
        +-- homescreen.dart
+-- utils/
    +-- constants.dart
+-- widgets/
+-- firebaseoptions.dart
+-- main.dart
```

---

## Setup Instructions

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)
- Project Firebase (develop in firebase.google.com)
- Google Maps API key

### Step 1: Configure Firebase

In the Firebase Console, create a project in Firebase.
Enabling the following Firebase services:
- Authentication (Email/Password)
- Cloud Firestore

Firestore (in production or test mode) This is created to store data in Firestore.
Initiate the authentication of Email/Password provider.

### Step 2: Set Up FlutterFire

Denote the FlutterFire configuration command:
```bash
cd kigalicityserviced
flutterfire configure
```

This command will:
- Ask you to choose your Firebase project.
- Create firebaseoptions.dart using your project settings.
- Firebase configurations It is recommended to update Android and iOS project files with Firebase configurations.

### Step 3: Configure Google Maps

Obtain Google Cloud Console key in Google Maps API.
Create a variant to add to Firebase project set-up.

**For Android** - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.APIKEY"
    android:value="YOURGOOGLEMAPSAPIKEY"/>
```

**For iOS** - Implement in `ios/Runner/GeneratedPluginRegistrant.m`, and in `AppDelegate.swift`.

### Step 4: Install Dependencies
```bash
flutter pub get
```

### Step 5: Run the Application
```bash
flutter run
```

---

## Firestore Database Schema

### Users Collection
```json
{
  "uid": "userid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "urlornull",
  "emailVerified": false,
  "notificationsEnabled": true,
  "createdAt": "2024-03-03T10:00:00Z"
}
```

### Listings Collection
```json
{
  "id": "listingid",
  "name": "Kigali Central Hospital",
  "category": "Hospital",
  "address": "123 Main Street, Kigali",
  "contactNumber": "+250788123456",
  "description": "Central hospital with an emergency.",
  "latitude": -1.9536,
  "longitude": 30.0606,
  "createdBy": "useruid",
  "createdAt": "2024-03-03T10:00:00Z",
  "bookmarkedBy": ["userid1", "userid2"]
}
```

---

## State Management

This application is based on provider to state:
- Pure separation between business and UI.
- Firestore updates must be in real-time.
- The rebuilding of widgets in an efficient way.
- Easy testability

### Key Providers
- **AuthProvider:** This is in charge of the state and profile of the user authentication.
- **ListingProvider:** CRUD and filters of listings.

---

## Navigation

It has a BottomNavigationBar of the Material Design used as a navigation tool between screens:
- **Search:** filters and peruses all listings that are available.
- **My Listings:** Manage your own listings.
- **Bookmarks:** Visit your favorite bookmarks.
- **Map:** Load all the listings using an interactive map.
- **Setting:** Privacy and account security.

---

## Location Services

The application has location services which:
- Get user permission on access to location.
- Get current device location
- Compute inter-coordinate distances.
- Fall to Kigali city center in case of unavailability of location.

---

## Search and Filtering

- Search results by case-insensitive name.
- Filter by category:
  - Hospital
  - Police Station
  - Library
  - Restaurant
  - Cafe
  - Park
  - Tourist Attraction
  - Pharmacy

The filters are combinable to provide specific outcome.

---

## Notifications

The app also has location-based notification preferences which are also to be turned on or off in settings. (Presently implemented is a local preference switch)

---

## Error Handling

The application has good error handling:
- Errors with firebase authentication.
- Connectivity problems in the network.
- Rejection of location permission.
- Invalid form inputs
- Failures in the work of databases.

---

## Security Notes

Firestore console Firebase Security Rules must be set up:
- Authenticated users are the only ones who can write/read.
- Only the user can make alterations on his or her listing.
- Any user can read a listing but creator can only edit/delete.
