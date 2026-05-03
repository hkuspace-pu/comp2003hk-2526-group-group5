import 'package:flutter/material.dart';

class AppStyles {
  // Border Radius (Matches your original Buttons and Cards)
  static BorderRadius cardRadius = BorderRadius.circular(16);
  static BorderRadius buttonRadius = BorderRadius.circular(12);

  // Common Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;

  // Global Text Styles
  static const TextStyle headingBold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle subtitleGrey = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle bodyGrey = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}