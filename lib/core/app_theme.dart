import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
        .copyWith(secondary: const Color(0xFF46AA57)),
  );
}
