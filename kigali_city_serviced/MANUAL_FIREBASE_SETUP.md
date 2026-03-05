# Firebase Manual Configuration Guide

Since the Firebase CLI requires additional setup on Windows, here's how to manually configure Firebase for your Flutter app.

## Step 1: Create Firebase Project

1. Go to https://firebase.google.com/
2. Click **"Go to console"** (top right)
3. Click **"Create a project"** or **"Add project"**
4. Enter project name: `kigali-city-services`
5. Click **"Continue"**
6. Enable Google Analytics (optional) → **"Continue"**
7. Select your region → **"Create project"**
8. Wait for project creation to complete

## Step 2: Get Firebase Configuration

After project creation, you'll see the Firebase console:

1. Click the **gear icon** (Settings) → **"Project settings"**
2. Go to **"General"** tab
3. Scroll down to find your Firebase config

### For Web:
Click **"Web"** icon (</>) and copy the config object that looks like:
```javascript
{
  "apiKey": "AIza...",
  "authDomain": "your-project.firebaseapp.com",
  "projectId": "your-project-id",
  "storageBucket": "your-project.appspot.com",
  "messagingSenderId": "123...",
  "appId": "1:123...:web:abc..."
}
```

### For Android:
Download the `google-services.json` file (available in Project Settings)

### For iOS:
Download the `GoogleService-Info.plist` file

## Step 3: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase config:

```dart
// For Web
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',           // from config.apiKey
  appId: 'YOUR_APP_ID',             // from config.appId
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',  // from config.messagingSenderId
  projectId: 'YOUR_PROJECT_ID',     // from config.projectId
);

// For Android
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'https://your-project-id.firebaseio.com',
);

// For iOS
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'https://your-project-id.firebaseio.com',
  iosBundleId: 'com.example.kigaliCityServiced',
);
```

## Step 4: Enable Firebase Services

### Enable Authentication:
1. In Firebase Console, go to **Build** → **Authentication**
2. Click **"Get Started"**
3. Click on **"Email/Password"**
4. Toggle **"Enable"** → **"Save"**

### Enable Firestore:
1. Go to **Build** → **Firestore Database**
2. Click **"Create database"**
3. Select region (same as your location)
4. Start in **"Test mode"** (for development)
5. Click **"Create"**

### Create Firestore Collections:
You don't need to create collections manually - they'll be created when your app writes data.

However, you can optionally create indexes ahead of time by going to **Firestore Database** → **Indexes** and setting up composite indexes for search queries.

## Step 5: Configure Google Maps API

### Get API Key:
1. Go to https://console.cloud.google.com/
2. Select or create a project matching your Firebase project
3. Search for **"Maps SDK for Android"** and **"Maps SDK for iOS"**
4. Click on each and enable them
5. Go to **"Credentials"** → **"Create Credentials"** → **"API Key"**
6. Copy your API key

### For Android:
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

### For iOS:
Edit `ios/Runner/GeneratedPluginRegistrant.m` and add at the top:
```objc
[GMSServices provideAPIKey:@"YOUR_GOOGLE_MAPS_API_KEY"];
```

### For Web:
Edit `web/index.html` in the `<head>` section:
```html
<script async
    src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY">
</script>
```

## Step 6: Add Location Permissions

### For Android:
Edit `android/app/src/main/AndroidManifest.xml` and add:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### For iOS:
Edit `ios/Runner/Info.plist` and add:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby services.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby services.</string>
</key>
```

## Step 7: Configure Firestore Security Rules

1. In Firebase Console, go to **Firestore Database** → **Rules** tab
2. Replace the default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone authenticated can read listings
    // Anyone authenticated can create listings
    // Only creator can update/delete
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```

3. Click **"Publish"**

## Step 8: Run Your App

```bash
cd kigali_city_serviced
flutter pub get
flutter run
```

## Troubleshooting

### "Firebase not initialized" Error
- Make sure `firebase_options.dart` has your correct Firebase config
- Check that the API key and project ID are correct
- Verify Firestore database is created

### "Google Maps not showing"
- Verify API key is correct in AndroidManifest.xml (Android)
- Check API key in Info.plist or GeneratedPluginRegistrant.m (iOS)
- Ensure Maps SDK for Android/iOS is enabled in Google Cloud Console

### "Permission denied" Firestore errors
- Make sure you're logged in (app shows Home screen)
- Check Firestore security rules
- Verify you're using test mode or rules are correct

### Location permissions not working
- Check AndroidManifest.xml has permission declarations
- Check Info.plist has location usage descriptions
- Run app and grant permissions when prompted

## Quick Checklist

- [ ] Firebase project created
- [ ] Authentication (Email/Password) enabled
- [ ] Firestore database created
- [ ] Firestore rules configured
- [ ] Google Maps API key obtained
- [ ] `firebase_options.dart` updated with your config
- [ ] AndroidManifest.xml updated with Maps API key and location permissions
- [ ] Info.plist updated with location permissions (iOS)
- [ ] App dependencies installed: `flutter pub get`
- [ ] App runs successfully: `flutter run`

## Testing the Setup

1. Run the app: `flutter run`
2. Create a test account (email must be valid for verification)
3. Check your email for verification link
4. Click verification link to verify email
5. App should show Home screen
6. Create a test listing
7. Check Firestore console - you should see your listing in the database

You're ready to go! 🚀
