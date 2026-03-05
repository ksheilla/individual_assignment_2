# Architecture & Design Patterns

This document describes the architecture and design patterns used in the Kigali City Services application.

## Overall Architecture

The application follows a **layered architecture** pattern with clear separation of concerns:

```
┌─────────────────────────────────┐
│         UI Layer                │
│    (Screens & Widgets)          │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│    State Management Layer       │
│      (Provider Classes)         │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│      Service Layer              │
│  (Business Logic & APIs)        │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│    Data Layer                   │
│ (Firebase, Local Storage)       │
└─────────────────────────────────┘
```

## 1. Models Layer

### Purpose
Defines data structures for the application.

### Files
- `user_model.dart` - User profile data
- `listing_model.dart` - Service/location listing data

### Key Features
- `toMap()` - Convert model to Firestore document
- `fromMap()` - Convert Firestore document to model
- `copyWith()` - Create modified copies for immutability

### Example
```dart
// Creating a model
final user = UserModel(
  uid: 'user123',
  email: 'user@example.com',
  displayName: 'John Doe',
  // ...
);

// Converting to Firestore
final firestoreData = user.toMap();

// Creating a copy with modifications
final updatedUser = user.copyWith(displayName: 'Jane Doe');
```

## 2. Services Layer

### Purpose
Encapsulates business logic and external API interactions.

### Files

#### AuthService
- **Responsibility**: Firebase Authentication operations
- **Methods**:
  - `signUp()` - Register new user
  - `signIn()` - Authenticate user
  - `signOut()` - Log out user
  - `sendEmailVerification()` - Send verification email
  - `getUserProfile()` - Fetch user data from Firestore
  - `updateUserProfile()` - Update user information

#### FirestoreService
- **Responsibility**: Firestore database operations (CRUD)
- **Methods**:
  - `createListing()` - Create new listing
  - `getListing()` - Get single listing
  - `getAllListings()` / `getAllListingsStream()` - Get all listings
  - `getUserListings()` / `getUserListingsStream()` - Get user's listings
  - `updateListing()` - Update listing
  - `deleteListing()` - Delete listing
  - `searchListings()` - Search by name
  - `addBookmark()` / `removeBookmark()` - Manage bookmarks

#### LocationService
- **Responsibility**: Geolocation operations
- **Methods**:
  - `getCurrentLocation()` - Get device location
  - `getLocationStream()` - Get continuous location updates
  - `calculateDistance()` - Calculate distance between coordinates

### Design Pattern: Service Singleton
Each service is instantiated once and reused:
```dart
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // ... methods
}
```

## 3. State Management Layer (Provider)

### Purpose
Manages application state and notifies UI of changes.

### Architecture Pattern: ChangeNotifier

#### AuthProvider
**Responsibility**: Authentication state management

**State Variables**:
- `_currentUser` - Currently logged in user
- `_userProfile` - User profile from Firestore
- `_isLoading` - Loading state
- `_error` - Error messages
- `_isEmailVerified` - Email verification status

**Key Methods**:
```dart
Future<void> signUp(...) async // Create account
Future<void> signIn(...) async // Login
Future<void> signOut() async // Logout
Future<void> checkEmailVerification() async // Check verification
void notifyListeners() // Notify UI of changes
```

#### ListingProvider
**Responsibility**: Listings CRUD and filtering

**State Variables**:
- `_allListings` - All listings from database
- `_filteredListings` - Filtered results
- `_userListings` - Current user's listings
- `_selectedCategory` - Active category filter
- `_searchQuery` - Search term

**Key Methods**:
```dart
Future<void> createListing(ListingModel) async
Future<void> updateListing(String id, ListingModel) async
Future<void> deleteListing(String id) async
void filterByCategory(String?) // Filter by category
void searchListings(String query) // Search by name
Future<void> addBookmark(String id, String userId) async
```

### Flow Example: Creating a Listing
```
UI (CreateListingScreen)
    │
    ├─> User fills form and taps "Create"
    │
    └─> Calls: listingProvider.createListing(listing)
        │
        └─> FirestoreService.createListing()
            │
            └─> Firebase Firestore (creates document)
                │
                └─> Returns listing ID
                    │
                    └─> ListingProvider updates _allListings
                        │
                        └─> notifyListeners()
                            │
                            └─> UI Rebuilds with new listing
```

## 4. Screens Layer

### Screen Hierarchy

#### Authentication Screens
```
LoginScreen → SignUpScreen
    ↓
EmailVerificationScreen
    ↓
HomeScreen (After verification)
```

#### Main Navigation Screens
```
HomeScreen (BottomNavigationBar)
    ├─> DirectoryScreen
    ├─> MyListingsScreen
    ├─> BookmarksScreen
    ├─> MapViewScreen
    └─> SettingsScreen
```

#### Supporting Screens
```
ListingDetailScreen ← Accessible from Directory, MyListings, Bookmarks
    ├─> EditListingScreen (for owners)
    └─> Maps (embedded)

CreateListingScreen ← Accessible from Directory, MyListings
```

### Screen Communication Pattern

Screens communicate through:
1. **Provider Consumer** - Read state
2. **Provider read()** - Trigger state changes
3. **Navigation** - Pass data between screens

```dart
// Reading state with Consumer
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.isAuthenticated) {
      // ...
    }
  },
);

// Triggering actions
context.read<ListingProvider>().createListing(listing);

// Passing data via navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ListingDetailScreen(listing: listing),
  ),
);
```

## 5. Data Flow Examples

### User Registration Flow
```
1. User enters details in SignUpScreen
2. User taps "Create Account"
3. SignUpScreen calls authProvider.signUp()
4. AuthProvider calls authService.signUp()
5. AuthService calls FirebaseAuth.createUserWithEmailAndPassword()
6. AuthService creates user document in Firestore
7. AuthService sends verification email
8. AuthProvider notifyListeners()
9. App navigates to EmailVerificationScreen
10. User verifies email
11. App navigates to HomeScreen
```

### Listing Creation Flow
```
1. User fills form in CreateListingScreen
2. Gets current location from LocationService
3. User taps "Create Listing"
4. CreateListingScreen calls listingProvider.createListing()
5. ListingProvider calls firestoreService.createListing()
6. FirestoreService adds document to Firestore
7. ListingProvider receives new listing ID
8. ListingProvider updates _allListings state
9. ListingProvider notifyListeners()
10. App navigates back to DirectoryScreen
11. DirectoryScreen rebuilds with new listing
```

### Search and Filter Flow
```
1. User types in search box (DirectoryScreen)
2. onChange: listingProvider.searchListings(query)
3. ListingProvider updates _searchQuery
4. ListingProvider calls _applyFilters()
5. _applyFilters() filters _allListings based on:
   - Search query (name match)
   - Category filter (if selected)
6. Updates _filteredListings
7. notifyListeners()
8. UI rebuilds showing filtered results
```

## Design Principles

### 1. Single Responsibility Principle
- Each class has one reason to change
- Services handle business logic only
- Providers manage state only
- Screens handle UI only

### 2. Dependency Injection
- Services are instantiated in providers
- Providers are injected via MultiProvider
- Easy to test and swap implementations

### 3. Immutability
- Models use `copyWith()` for updates
- State is not mutated directly
- New objects created on changes

### 4. Reactive Programming
- Providers notify listeners on state changes
- Streams for real-time updates from Firestore
- UI automatically rebuilds when data changes

### 5. Error Handling
- Each layer handles its own errors
- Errors propagated up to UI via providers
- User feedback through SnackBars or dialogs

## State Management Lifecycle

### Provider Initialization
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ListingProvider()),
  ],
  // ...
);
```

### During App Runtime
```
1. User action in UI
2. State modification through provider
3. notifyListeners() called
4. Consumer widgets rebuild
5. UI reflects new state
```

### Provider Cleanup
- Providers are disposed when no longer needed
- Firestore listeners automatically cleaned up
- Auth state changes tracked automatically

## Testing Approach

Each layer can be tested independently:

### Unit Tests
- Model serialization/deserialization
- Business logic in services
- State transitions in providers

### Widget Tests
- Individual screen layouts
- User interactions
- Provider integration

### Integration Tests
- Full user flows
- Authentication to listing creation
- Database operations

## Extension Points

The architecture supports easy additions:

### Add New Feature
1. Define model in `models/`
2. Create service in `services/`
3. Create provider in `providers/`
4. Create screens in `screens/`

### Add New Service
1. Create service class (e.g., `ReviewService`)
2. Add method to existing provider or create new provider
3. Use in screens via Consumer

### Add New Screen
1. Create screen widget in appropriate folder
2. Connect to providers via Consumer
3. Add navigation route
4. Update BottomNavigationBar if main screen

## Performance Considerations

### Optimization Techniques
- **Lazy Loading**: Firestore loads data on demand
- **Pagination**: Can be added for large datasets
- **Caching**: Local caching could be added
- **Indexing**: Firestore queries optimized with appropriate indexes
- **Efficient Rebuilds**: Consumer widgets only rebuild when data changes

### Memory Management
- Stream subscriptions properly managed
- Listeners cleaned up on dispose
- Large lists use efficient builders

## Security Considerations

### Authentication
- Email/password stored securely by Firebase
- Session managed by Firebase Auth
- JWT tokens handled automatically

### Authorization
- Firestore Rules enforce user permissions
- Users can only modify their own listings
- Read access controlled per collection

### Data Privacy
- No sensitive data in logs
- API keys stored securely
- User data encrypted in transit and at rest
