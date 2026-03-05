import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new listing
  Future<String> createListing(ListingModel listing) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.listingsCollection)
          .add(listing.toMap());
      return doc.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get all listings
  Future<List<ListingModel>> getAllListings() async {
    try {
      final query =
          await _firestore.collection(AppConstants.listingsCollection).get();
      return query.docs
          .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get all listings stream
  Stream<List<ListingModel>> getAllListingsStream() {
    return _firestore
        .collection(AppConstants.listingsCollection)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get listings by user
  Future<List<ListingModel>> getUserListings(String userId) async {
    try {
      final query = await _firestore
          .collection(AppConstants.listingsCollection)
          .where('createdBy', isEqualTo: userId)
          .get();
      return query.docs
          .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get listings by user stream
  Stream<List<ListingModel>> getUserListingsStream(String userId) {
    return _firestore
        .collection(AppConstants.listingsCollection)
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get listings by category
  Future<List<ListingModel>> getListingsByCategory(String category) async {
    try {
      final query = await _firestore
          .collection(AppConstants.listingsCollection)
          .where('category', isEqualTo: category)
          .get();
      return query.docs
          .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get listings by category stream
  Stream<List<ListingModel>> getListingsByCategoryStream(String category) {
    return _firestore
        .collection(AppConstants.listingsCollection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Search listings by name
  Future<List<ListingModel>> searchListings(String query) async {
    try {
      final listings = await _firestore
          .collection(AppConstants.listingsCollection)
          .get();
      return listings.docs
          .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .where((listing) =>
              listing.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single listing by ID
  Future<ListingModel?> getListing(String listingId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .get();

      if (doc.exists) {
        return ListingModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update listing
  Future<void> updateListing(String listingId, ListingModel listing) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .update(listing.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  // Add bookmark
  Future<void> addBookmark(String listingId, String userId) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .update({
        'bookmarkedBy': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(String listingId, String userId) async {
    try {
      await _firestore
          .collection(AppConstants.listingsCollection)
          .doc(listingId)
          .update({
        'bookmarkedBy': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get user bookmarks
  Future<List<ListingModel>> getUserBookmarks(String userId) async {
    try {
      final query = await _firestore
          .collection(AppConstants.listingsCollection)
          .where('bookmarkedBy', arrayContains: userId)
          .get();
      return query.docs
          .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get user bookmarks stream
  Stream<List<ListingModel>> getUserBookmarksStream(String userId) {
    return _firestore
        .collection(AppConstants.listingsCollection)
        .where('bookmarkedBy', arrayContains: userId)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => ListingModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
