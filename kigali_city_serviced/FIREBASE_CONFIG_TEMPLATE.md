# firebase_options.dart Configuration Template

## How to Find Your Firebase Configuration Values

This guide shows you exactly where to find each value you need to paste into `firebase_options.dart`.

### Step 1: Go to Firebase Console

1. Navigate to https://console.firebase.google.com/
2. Select your project "kigali-city-services"
3. Click the **Settings gear icon** (⚙️) in the top left
4. Click **"Project settings"**

### Step 2: Find Your Configuration Values

You should now see a page with your project information. Look for these values:

```
Project ID:              kigali-city-services (or your-project-id)
API Key:                 AIza... (long string)
Auth Domain:             your-project-id.firebaseapp.com
Messaging Sender ID:     123456789 (numbers only)
App ID:                  1:123456789:web:abc... (web app ID)
Storage Bucket:          your-project-id.appspot.com
Database URL:            https://your-project-id.firebaseio.com
```

### Step 3: Locate the Web App Config

Scroll down on the Project Settings page to find the section titled **"Your apps"**.

If you haven't created a web app yet:
1. Click the **"Web"** icon (</> symbol)
2. Register your web app with nickname "Kigali City Services"
3. Click to show the Firebase config
4. Copy all the values

If you already have a web app:
1. Click on the web app name
2. Scroll down to find the Firebase config

### Step 4: Update firebase_options.dart

Now open `lib/firebase_options.dart` in VS Code and update it with your values.

#### For WEB Configuration:

Replace:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
);
```

With (example values):
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:web:abcdefghij1234567',
  messagingSenderId: '123456789',
  projectId: 'kigali-city-services',
);
```

#### For ANDROID Configuration:

1. Download `google-services.json` from Firebase Console:
   - Project Settings → **"Your apps"** → Select Android app
   - Click "Download google-services.json"
   
2. Place it at: `android/app/google-services.json`

3. Update `android/app/build.gradle`:
```gradle
dependencies {
    // Add this line
    classpath 'com.google.gms:google-services:4.3.15'
}
```

4. Update `android/app/build.gradle` (in the android section):
```gradle
apply plugin: 'com.google.gms.google-services'
```

5. Update `firebase_options.dart`:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:android:abcdefghij1234567',
  messagingSenderId: '123456789',
  projectId: 'kigali-city-services',
  databaseURL: 'https://kigali-city-services.firebaseio.com',
);
```

#### For iOS Configuration:

1. Download `GoogleService-Info.plist` from Firebase Console:
   - Project Settings → **"Your apps"** → Select iOS app
   - Click "Download GoogleService-Info.plist"

2. Place it in Xcode:
   - Open `ios/Runner.xcworkspace` (NOT Runner.xcodeproj)
   - Right-click on **"Runner"** folder → **"Add Files to Runner"**
   - Select the `GoogleService-Info.plist` file
   - Check **"Copy items if needed"** → **"Add"**

3. Update `firebase_options.dart`:
```dart
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:ios:abcdefghij1234567',
  messagingSenderId: '123456789',
  projectId: 'kigali-city-services',
  databaseURL: 'https://kigali-city-services.firebaseio.com',
  iosBundleId: 'com.example.kigaliCityServiced',
);
```

#### For macOS Configuration (if needed):

```dart
static const FirebaseOptions macos = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:ios:abcdefghij1234567',
  messagingSenderId: '123456789',
  projectId: 'kigali-city-services',
  databaseURL: 'https://kigali-city-services.firebaseio.com',
  iosBundleId: 'com.example.kigaliCityServiced.macos',
);
```

#### For Windows Configuration (if needed):

```dart
static const FirebaseOptions windows = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:windows:abcdefghij1234567',
  messagingSenderId: '123456789',
  projectId: 'kigali-city-services',
  authDomain: 'kigali-city-services.firebaseapp.com',
);
```

## Quick Reference: Where to Find Each Value

| Value | Where to find it |
|-------|------------------|
| `apiKey` | Firebase Console > Project Settings > Web App Config > apiKey |
| `appId` | Firebase Console > Project Settings > Web App Config > appId |
| `messagingSenderId` | Firebase Console > Project Settings > messagingSenderId |
| `projectId` | Firebase Console > Project Settings > projectId |
| `authDomain` | Firebase Console > Project Settings > authDomain |
| `databaseURL` | Firebase Console > Project Settings > databaseURL |
| `storageBucket` | Firebase Console > Project Settings > storageBucket |
| `iosBundleId` | Find in ios/Runner/Info.plist key "CFBundleIdentifier" |

## Testing Your Configuration

After updating `firebase_options.dart`:

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

The app should now:
1. Show the Login screen
2. Allow you to create an account
3. Send a verification email
4. Let you log in after verification
5. Allow you to create listings

## Common Misconfigurations

### ❌ Wrong API Key
- **Symptom**: Authentication fails
- **Fix**: Copy exact API key from Firebase Console (with 'AIza' prefix)

### ❌ Wrong Project ID
- **Symptom**: Firestore permission errors
- **Fix**: Use your exact project ID (lowercase, with hyphens)

### ❌ Missing google-services.json (Android)
- **Symptom**: Cannot build for Android
- **Fix**: Download and place in `android/app/google-services.json`

### ❌ Missing GoogleService-Info.plist (iOS)
- **Symptom**: Cannot build for iOS
- **Fix**: Download and add via Xcode to ios/Runner folder

### ❌ Wrong Bundle ID
- **Symptom**: iOS app won't recognize Firebase credentials
- **Fix**: Ensure `iosBundleId` matches the one in Info.plist

## Need Help?

If you get errors like:
- "Firebase not initialized" → Check projectId is correct
- "Authentication failed" → Check apiKey is correct
- "Permission denied" → Check Firestore rules are in test mode
- "Google Maps blank" → Check Google Maps API key

Refer to `MANUAL_FIREBASE_SETUP.md` for detailed troubleshooting.
