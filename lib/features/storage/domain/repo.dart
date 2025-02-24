import 'dart:io';

abstract class UploadProfileImageStoregeRepo {
  Future<String?> uploadToStorage({
    required String name,
    required File file,
  });
}
