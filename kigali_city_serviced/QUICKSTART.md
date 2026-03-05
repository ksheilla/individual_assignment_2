# Quick Start Guide

Get started with Kigali City Services in 5 minutes!

## 1. Prerequisites ✓
- Flutter SDK installed
- Firebase account created
- Google Maps API key obtained

## 2. Firebase Configuration (5 min)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
cd kigali_city_serviced
flutterfire configure

# Select your Firebase project when prompted
```

See [SETUP.md](SETUP.md) for detailed Firebase configuration.

## 3. Run the App (2 min)

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 4. First Steps in the App

### Create Account
1. Tap **"Sign Up"** button
2. Enter:
   - Display Name
   - Email address
   - Password (min 6 characters)
3. Tap **"Create Account"**
4. Check email for verification link
5. Return to app and tap **"I have verified my email"**

### Explore Directory
1. You'll see the **Directory** tab (home)
2. Browse listings or use search
3. Use category filters (Hospital, Restaurant, etc.)
4. Tap any listing to see details

### Create a Listing
1. Tap the **"+"** icon in Directory or MyListings
2. Fill in:
   - Name (e.g., "Best Café in Kigali")
   - Category
   - Address
   - Contact Number
   - Description
3. Location is auto-detected or defaults to Kigali center
4. Tap **"Create Listing"**

### Use Bookmarks
1. Open any listing detail
2. Tap the **bookmark icon** (top right)
3. Access saved listings in **Bookmarks** tab

### View on Map
1. Go to **Map** tab
2. See all listings pinned on the map
3. Tap any marker to see listing details

### Manage Your Listings
1. Go to **My Listings** tab
2. See all your created listings
3. Tap **"..."** to edit or delete

### Settings
1. Go to **Settings** tab
2. View your profile information
3. Toggle **"Location-based Notifications"**
4. Tap **"Sign Out"** to logout

## Key Features

| Feature | Location | How to Use |
|---------|----------|-----------|
| Full Search | Directory | Type in search box |
| Category Filter | Directory | Tap category chip |
| Create Listing | Directory, MyListings | Tap + icon |
| Edit/Delete | Each listing detail | Tap ... menu |
| Bookmark | Listing detail | Tap bookmark icon |
| View Map | Map tab | View all listings |
| Get Directions | Listing detail | Tap "Get Directions" |
| Call Service | Listing detail | Tap phone number |

## Test Data

### Sample Listings to Create
```
1. Kigali Central Hospital
   Category: Hospital
   Address: KN 2 Ave, Kigali
   Contact: +250788123456
   Latitude: -1.9536
   Longitude: 30.0606

2. Green Bean Coffee
   Category: Café
   Address: Kigali Business Centre
   Contact: +250788654321
   Latitude: -1.9556
   Longitude: 30.0586

3. Volcanoes National Park
   Category: Tourist Attraction
   Address: Northern Rwanda
   Contact: +250788999888
   Latitude: -1.4959
   Longitude: 29.5679
```

## Troubleshooting

### App Won't Start?
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Firebase Not Working?
- Run `flutterfire configure` again
- Check internet connection
- Verify Firebase rules are in test mode

### Google Maps Showing Blank?
- Verify API key in AndroidManifest.xml (Android)
- Check API key in ios/Runner/Info.plist (iOS)
- Ensure Maps API is enabled in Google Cloud Console

### Can't Sign Up?
- Use a valid email address
- Password must be at least 6 characters
- Check Firebase Authentication is enabled

### Listings Not Appearing?
- Ensure you're signed in
- Check Firestore database exists
- Verify Firestore rules allow reads
- Try refreshing the app

## Common Tasks

### To Search for a Listing
1. Go to Directory
2. Type in the search box
3. Results filter in real-time

### To Filter by Category
1. Go to Directory
2. Tap category chip (Hospital, Restaurant, etc.)
3. Tap "All" to clear filter

### To Edit Your Listing
1. Go to My Listings
2. Tap the listing
3. Tap "..." in top menu
4. Select "Edit"
5. Modify and tap "Update Listing"

### To Delete a Listing
1. Go to My Listings
2. Tap the listing
3. Tap "..." in top menu
4. Select "Delete"
5. Confirm deletion

### To Navigate to a Location
1. Open any listing
2. Scroll to see map
3. Tap "Get Directions" button
4. Google Maps opens with directions

### To Enable/Disable Notifications
1. Go to Settings
2. Toggle "Location-based Notifications"
3. Change is saved automatically

## Architecture Overview

```
Login/Signup
    ↓
Email Verification
    ↓
Home Screen (BottomNavigationBar with 5 tabs)
├─ Directory (Browse + Create)
├─ My Listings (Manage your listings)
├─ Bookmarks (Saved listings)
├─ Map (All locations)
└─ Settings (Profile + Preferences)
```

## File Structure

```
kigali_city_serviced/
├── lib/
│   ├── main.dart (Entry point)
│   ├── models/ (Data structures)
│   ├── services/ (Business logic)
│   ├── providers/ (State management)
│   ├── screens/ (UI screens)
│   └── utils/ (Constants & helpers)
├── README.md (Full documentation)
├── SETUP.md (Firebase setup guide)
├── ARCHITECTURE.md (Technical details)
└── pubspec.yaml (Dependencies)
```

## Next Steps

1. ✓ Setup Firebase (see SETUP.md)
2. ✓ Run the app
3. Create a test account
4. Create sample listings
5. Test all features
6. Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand code structure

## Support

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.flutter.dev/
- **Google Maps**: https://pub.dev/packages/google_maps_flutter

## Tips & Tricks

- **Bookmark listings**: Tap the bookmark icon to save for later
- **Quick call**: Tap the phone number to call directly
- **Get directions**: Tap "Get Directions" to launch Google Maps
- **Search tips**: Search is case-insensitive and searches listing names
- **Location**: Location is auto-detected but always defaults to Kigali if unavailable

Happy exploring! 🗺️
