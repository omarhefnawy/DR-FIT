import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dr_fit/features/storage/domain/repo.dart';

class UploadProfileImageStorageRepoImp
    implements UploadProfileImageStoregeRepo {
  final FirebaseStorage store = FirebaseStorage.instance;

  @override
  Future<String?> uploadToStorage({
    required String name,
    required File file,
  }) async {
    try {
      // Ensure the file exists before proceeding
      if (!file.existsSync()) {
        print('❌ File does not exist at path: ${file.path}');
        return null;
      }

      // Create a unique filename
      String fileName = "$name-${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = store.ref('DB/$fileName'); // Store inside 'DB/' folder

      // Upload the file
      await ref.putFile(file);
      final url = await ref.getDownloadURL(); // Get the download URL

      print('✅ Image uploaded successfully: $url');
      return url;
    } catch (e) {
      print('❌ Error uploading image: $e'); // Debugging
      return null;
    }
  }
}
