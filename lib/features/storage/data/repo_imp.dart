import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadProfileImageStorageRepoImp {
  final FirebaseStorage store = FirebaseStorage.instance;

  Future<String?> uploadToStorage({
    required String name,
    required File file,
  }) async {
    try {
      // Ensure user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ User not authenticated");
        return null;
      }

      // Ensure file exists
      if (!file.existsSync()) {
        print('❌ File does not exist at path: ${file.path}');
        return null;
      }

      // Create a unique filename
      String fileName = "$name-${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = store.ref('DB/$fileName');

      // Upload file with metadata
      await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Get download URL
      final url = await ref.getDownloadURL();
      print('✅ Image uploaded successfully: $url');

      return url;
    } on FirebaseException catch (e) {
      print('❌ Firebase Storage Error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('❌ Unexpected Error: $e');
      return null;
    }
  }
}
