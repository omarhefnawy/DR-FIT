import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/profile/data/model/user_data.dart';
import 'package:dr_fit/features/profile/domain/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final firestore = FirebaseFirestore.instance;

  // ProfileRepoImpl({required this.firestore});

  @override
  Future<ProfileData?> fetchData({required String uid}) async {
    try {
      DocumentSnapshot document =
          await firestore.collection('users').doc(uid).get();

      if (document.exists) {
        final data = document.data() as Map<String, dynamic>;

        return ProfileData(
          uid: uid,
          name: data['name'] ?? '',
          weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
          height: (data['height'] as num?)?.toDouble() ?? 0.0,
          age: data['age'] ?? '', // Assuming age is an integer
          phone: data['phone'] ?? '',
          img: data['img'] ?? '',
        );
      }
      return null; // Document does not exist
    } catch (e) {
      throw Exception('Error fetching profile data: ${e.toString()}');
    }
  }

  @override
  Future<ProfileData?> updateData({required ProfileData updated}) async {
    try {
      await firestore.collection('users').doc(updated.uid).update({
        'name': updated.name,
        'age': updated.age,
        'phone': updated.phone,
        'height': updated.height,
        'weight': updated.weight,
        'img': updated.img,
      });

      // Return the updated object
      return updated;
    } catch (e) {
      throw Exception('Error updating profile data: ${e.toString()}');
    }
  }
}
