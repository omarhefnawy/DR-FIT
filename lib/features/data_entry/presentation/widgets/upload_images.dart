import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

Future<String> uploadImage(File image) async {
  try {
    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Define a reference to the storage path
    Reference storageReference =
        _firebaseStorage.ref().child('profile_images/$userId.jpg');

    // Upload the image file to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(image);

    // Wait for the upload to complete and get the download URL
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl; // Return the image URL
  } catch (e) {
    print("Error uploading image: $e");
    return ""; // Return an empty string in case of an error
  }
}
