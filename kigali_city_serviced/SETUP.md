# Firebase Setup Guide for Kigali City Services

This guide will help you configure Firebase for the Kigali City Services & Places Directory application.

## Prerequisites

Before starting, make sure you have:
- Flutter SDK installed
- A Google account
- Terminal/Command line access
- A code editor (VS Code recommended)

## Firebase Project Creation

### 1. Create a Firebase Project

1. Go to https://console.firebase.google.com/
2. Click **"Create a project"** or **"Add project"**
3. Enter a project name: `kigali-city-services`
4. Accept the terms and click **"Continue"**
5. Choose your location and click **"Create project"**
6. Wait for the project to be created

### 2. Enable Firebase Services

#### Enable Authentication

1. In the Firebase Console, go to **Build** > **Authentication**
2. Click **"Get Started"**
3. Under **"Sign-in method"**, click on **"Email/Password"**
4. Toggle **"Enable"** and click **"Save"**
5. Keep other options disabled for now

#### Enable Cloud Firestore

1. In the Firebase Console, go to **Build** > **Firestore Database**
2. Click **"Create database"**
3. Choose your region (closest to your location)
4. Select **"Test mode"** for initial development
   - (Switch to production mode after setting up security rules)
5. Click **"Create"**

#### Enable Google Maps

For Google Maps integration, you'll need an API key from Google Cloud Console:

1. Go to https://console.cloud.google.com/
2. Create a new project or select your existing one
3. Search for **"Maps SDK for Android"** or **"Maps SDK for iOS"**
4. Enable both APIs
5. Go to **Credentials** in the left sidebar
6. Create an **API Key**
7. Note down your API key for later

## Setup FlutterFire CLI

### 1. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 2. Configure FlutterFire

```bash
cd kigali_city_serviced
flutterfire configure
```

This command will:
- Ask to select your Firebase project
- Automatically download and configure Firebase for all platforms
- Create `firebase_options.dart` with your project configuration
- Update Android and iOS configuration files

Follow the prompts and select your Firebase project when asked.

## Android Configuration

### 1. Add Google Maps API Key

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Add this inside the application tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
    
    <!-- Rest of existing configuration -->
</application>
```

### 2. Add Location Permissions

Ensure `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### 3. Verify Gradle Configuration

Check `android/app/build.gradle` has:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## iOS Configuration

### 1. Add Google Maps API Key

Open `ios/Runner/GeneratedPluginRegistrant.m` and add:

```objc
[GMSServices provideAPIKey:@"YOUR_GOOGLE_MAPS_API_KEY"];
```

### 2. Add Location Permissions

Edit `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby services.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby services.</string>
```

### 3. Update CocoaPods

```bash
cd ios
pod update
cd ..
```

## Firestore Security Rules

Once your app is working, update your Firestore security rules:

1. In Firebase Console, go to **Firestore Database** > **Rules**
2. Replace the rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read and write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone authenticated can read listings
    // Anyone authenticated can create listings
    // Only the creator can update/delete their listing
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```

3. Click **"Publish"**

## Web Configuration (Optional)

If you want to run on web:

1. Run `flutterfire configure` and select web when prompted
2. Your `firebase_options.dart` will include web configuration
3. Update `index.html` to include Google Maps:

```html
<script async
    src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY">
</script>
```

## Running the App

After configuration:

```bash
# Get dependencies
flutter pub get

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run on web (if configured)
flutter run -d web
```

## Verifying Configuration

1. Your app should show the Login screen
2. Create a test account with email and password
3. You should receive a verification email
4. After verification, you can access the app

## Troubleshooting

### "firebaseAuth/configuration-not-found" Error

**Solution**: Run `flutterfire configure` again

### "google_maps_flutter not initialized" Error

**Solution**: 
- Verify Google Maps API key is correctly added
- Make sure Maps API is enabled in Google Cloud Console
- Restart your device/simulator

### Firestore "Permission denied" Error

**Solution**:
- Make sure you're authenticated
- Check Firestore rules allow the operation
- Verify you're in test mode or rules are correctly set

### App Crashes on Map View

**Solution**:
- Check Google Maps API key is valid
- Ensure API key has Maps API enabled
- For iOS, verify Info.plist location permissions

## Next Steps

1. Create test user accounts
2. Add sample listings from the app
3. Test all features (search, filter, map, bookmarks)
4. Deploy to app stores when ready

## Support Resources

- Firebase Documentation: https://firebase.google.com/docs
- Flutter Firebase: https://firebase.flutter.dev/
- Google Maps Flutter: https://pub.dev/packages/google_maps_flutter
