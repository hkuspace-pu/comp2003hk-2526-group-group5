import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads activity images to Firebase Storage.
  /// Dynamically handles browser raw bytes for Web or local system paths for Mobile.
  Future<String> uploadActivityMedia({
    required String uid,
    required String fileName,
    Uint8List? fileBytes, // Used exclusively on Web platforms
    String? filePath,     // Used exclusively on Mobile platforms
  }) async {

    // Path configuration: activities/{uid}/{fileName}
    Reference ref = _storage.ref().child('activities').child(uid).child(fileName);
    UploadTask uploadTask;

    if (kIsWeb) {
      // Web flow: requires raw memory bytes
      if (fileBytes == null) throw Exception("Web upload requires file bytes.");

      // Set the metadata content type to ensure the browser displays the image correctly
      uploadTask = ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
    } else {
      // Mobile flow: requires structural file path string
      if (filePath == null) throw Exception("Mobile upload requires a file path.");

      uploadTask = ref.putFile(io.File(filePath));
    }

    // Await upload completion
    TaskSnapshot snapshot = await uploadTask;

    // Retrieve and return the public storage download URL
    return await snapshot.ref.getDownloadURL();
  }
}