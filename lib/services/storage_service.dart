import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Uploads media and returns the public Download URL
  // Matches your requirement for attaching photos/videos to activities
  Future<String> uploadActivityMedia(String uid, File file) async {
    // Generate a unique filename using timestamp
    String fileName = "${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}";

    // Path: activities/{uid}/{fileName}
    Reference ref = _storage.ref().child('activities').child(uid).child(fileName);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    // Return the URL to be saved in Firestore
    return await snapshot.ref.getDownloadURL();
  }
}