import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final ImageProvider? customerImage;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.customerImage,
  });
}
