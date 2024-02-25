import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_nepal/services/firebase_service.dart'; // Ensure this file provides access to Firebase Storage

class FileUpload {
  // Assuming FirebaseService has a getter for Firebase Storage reference
  final Reference storage = FirebaseService.storageRef;

  Future<ImagePath?> uploadImage({required String selectedPath, String? deletePath}) async {
    try {
      String dt = DateTime.now().millisecondsSinceEpoch.toString();
      if (deletePath != null) {
        await storage.child(deletePath).delete();
      }
      var photo = await storage.child("products/$dt.jpg").putFile(File(selectedPath));
      String photoUrl = await photo.ref.getDownloadURL();
      return ImagePath(
        imageUrl: photoUrl,
        imagePath: photo.ref.fullPath,
      );
    } catch (e) {
      print('Error uploading image: $e'); // Consider using a logging package for better error handling
      return null;
    }
  }

  Future<bool> deleteImage({String? deletePath}) async {
    if (deletePath == null) return false;
    try {
      await storage.child(deletePath).delete();
      return true;
    } catch (e) {
      print('Error deleting image: $e'); // Consider using a logging package for better error handling
      return false;
    }
  }
}

class ImagePath {
  ImagePath({
    this.imageUrl,
    this.imagePath,
  });

  final String? imageUrl;
  final String? imagePath;
}
