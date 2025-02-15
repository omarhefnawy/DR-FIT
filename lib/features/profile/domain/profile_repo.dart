import 'package:dr_fit/features/profile/data/model/user_data.dart';

abstract class ProfileRepo {
  Future<ProfileData?> fetchData({required String uid});
  Future<ProfileData?> updateData({required ProfileData updated});
}
