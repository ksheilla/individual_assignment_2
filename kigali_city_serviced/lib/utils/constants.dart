import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Kigali City Services';

  // Categories
  static const List<String> categories = [
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Pharmacy',
  ];

  // Firestore collections
  static const String usersCollection = 'users';
  static const String listingsCollection = 'listings';

  // Default coordinates for Kigali City
  static const double kigaliLatitude = -1.9536;
  static const double kigaliLongitude = 30.0606;

  // Map zoom level
  static const double mapZoomLevel = 15.0;

  // Colors
  static const Color primaryColor = Color(0xFF0F766E); // Teal
  static const Color secondaryColor = Color(0xFFF97316); // Orange
  static const Color tertiaryColor = Color(0xFF8B5CF6); // Purple
  static const Color backgroundColor = Color(0xFF0A0E27); // Deep dark blue
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color errorColor = Color(0xFFDC2626); // Red
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color infoColor = Color(0xFF3B82F6); // Blue
  static const Color textPrimary = Color(0xFFF1F5F9); // White
  static const Color textSecondary = Color(0xFFCBD5E1); // Light gray
  static const Color borderColor = Color(0xFF334155); // Dark gray
}
