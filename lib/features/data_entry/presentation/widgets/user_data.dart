import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/data_entry/model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveUserData(UserData userData) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Save the user data in Firestore, using the userId as the document ID
    await _firestore.collection('users').doc(userId).set(userData.toMap());
    print("User data saved successfully.");
  } catch (e) {
    print("Error saving user data: $e");
  }
}
