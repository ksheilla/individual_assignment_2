import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/listing_model.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ListingModel> _allListings = [];
  List<ListingModel> _filteredListings = [];
  List<ListingModel> _userListings = [];
  List<ListingModel> _bookmarkedListings = [];
  
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;
  String _searchQuery = '';

  List<ListingModel> get allListings => _filteredListings;
  List<ListingModel> get userListings => _userListings;
  List<ListingModel> get bookmarkedListings => _bookmarkedListings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Load all listings
  Future<void> loadAllListings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allListings = await _firestoreService.getAllListings();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all listings stream
  Stream<List<ListingModel>> getAllListingsStream() {
    return _firestoreService.getAllListingsStream();
  }

  // Load user listings
  Future<void> loadUserListings(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userListings = await _firestoreService.getUserListings(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user listings stream
  Stream<List<ListingModel>> getUserListingsStream(String userId) {
    return _firestoreService.getUserListingsStream(userId);
  }

  // Load bookmarked listings
  Future<void> loadBookmarkedListings(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookmarkedListings = await _firestoreService.getUserBookmarks(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get bookmarked listings stream
  Stream<List<ListingModel>> getBookmarkedListingsStream(String userId) {
    return _firestoreService.getUserBookmarksStream(userId);
  }

  // Create listing
  Future<String> createListing(ListingModel listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final id = await _firestoreService.createListing(listing);
      _allListings.add(listing.copyWith(id: id));
      _applyFilters();
      return id;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update listing
  Future<void> updateListing(String listingId, ListingModel listing) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.updateListing(listingId, listing);
      final index = _allListings.indexWhere((l) => l.id == listingId);
      if (index != -1) {
        _allListings[index] = listing;
        _applyFilters();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.deleteListing(listingId);
      _allListings.removeWhere((l) => l.id == listingId);
      _userListings.removeWhere((l) => l.id == listingId);
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search listings
  void searchListings(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Apply filters
  void _applyFilters() {
    _filteredListings = _allListings.where((listing) {
      bool matchesCategory = _selectedCategory == null ||
          listing.category == _selectedCategory;
      bool matchesSearch = _searchQuery.isEmpty ||
          listing.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  // Add bookmark
  Future<void> addBookmark(String listingId, String userId) async {
    try {
      await _firestoreService.addBookmark(listingId, userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(String listingId, String userId) async {
    try {
      await _firestoreService.removeBookmark(listingId, userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Check if listing is bookmarked
  bool isListingBookmarked(String listingId, String userId) {
    return _bookmarkedListings.any((l) => l.id == listingId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _applyFilters();
  }
}
