import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/profile/data/model/user_data.dart';
import 'package:dr_fit/features/profile/data/profile_repo_imp.dart';
import 'package:dr_fit/features/profile/presentation/profile_states.dart';
import 'package:dr_fit/features/storege/data/repo_imp.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final profileRepo = ProfileRepoImpl();

  ProfileCubit() : super(ProfileInitial());

  final _firestore = FirebaseFirestore.instance;

  Future<ProfileData?> fetchData({required String uid}) async {
    try {
      emit(ProfileLoading());
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        print('❌ No user data found in Firestore for UID: $uid');
        return null;
      }

      print('✅ Data fetched successfully for UID: ${doc.data()}');
      emit(ProfileLoaded(
          profileData:
              ProfileData.fromMap(uid, doc.data() as Map<String, dynamic>)));

      return ProfileData.fromMap(uid, doc.data() as Map<String, dynamic>);
    } catch (e) {
      emit(ProfileFail(message: 'error fetching data${e.toString()}'));
      print('❌ Error fetching profile data: $e');
      return null;
    }
  }

  Future<void> updateProfile({required ProfileData data}) async {
    try {
      emit(ProfileLoading());

      final updatedProfile =
          await profileRepo.updateData(updated: data); // تحديث البيانات

      if (updatedProfile != null) {
        print('✅ Profile updated: ${updatedProfile.name}'); // Debugging
        // 🔹 إعادة جلب البيانات بعد التحديث لضمان عرض أحدث نسخة
        final refreshedProfile =
            await profileRepo.fetchData(uid: updatedProfile.uid);
        emit(ProfileLoaded(profileData: updatedProfile));
        // إرسال البيانات الجديدة
      } else {
        emit(ProfileFail(
            message: 'Failed to update profile data')); // Emit fail state
      }
    } catch (e) {
      emit(ProfileFail(
          message: 'Error updating data: ${e.toString()}')); // Emit fail state
    }
  }
}
