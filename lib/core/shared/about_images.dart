import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  static final ImagePicker picker = ImagePicker(); // تعريف الـ picker

  static Future<File?> compressImage(File file, {int quality = 50}) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final outPath = "${filePath.substring(0, lastIndex)}_compressed.jpg";

      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: 50, // نسبة الجودة (كلما قل الرقم زادت نسبة الضغط)
      );

      return File(result!.path);
    } catch (e) {
      print('❌ خطأ أثناء ضغط الصورة: ${e.toString()}');
      return null;
    }
  }

  static Future<File?> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null; // التحقق إذا لم يحدد المستخدم صورة

      File imageFile = File(pickedFile.path); // تحويل `PickedFile` إلى `File`
      return await compressImage(imageFile); // ضغط الصورة وإرجاعها
    } catch (e) {
      print('❌ خطأ أثناء اختيار الصورة: ${e.toString()}');
      return null;
    }
  }

  // ✅ رفع الصورة إلى Firebase Storage
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final storege = FirebaseStorage.instance;
      String fileName = "posts/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = storege.ref(fileName);
      final upload = await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("❌ خطأ أثناء رفع الصورة: ${e.toString()}");
      return null;
    }
  }
}
