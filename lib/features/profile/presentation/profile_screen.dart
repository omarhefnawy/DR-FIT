import 'package:dr_fit/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_fit/features/profile/presentation/edit_profile.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:dr_fit/features/profile/presentation/profile_states.dart';
import 'package:dr_fit/features/profile/data/model/user_data.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data when the screen is first built
    context.read<ProfileCubit>().fetchData(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'الملف الشخصي',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profileData;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // صورة دائرية للملف الشخصي
                  Center(
                    child: CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 60,
                        backgroundImage: profile.img.isNotEmpty
                            ? NetworkImage(
                                profile.img,
                              )
                            : AssetImage(
                                'assets/logo/logo.png',
                              )),
                  ),
                  const SizedBox(height: 16),

                  // معلومات المستخدم في كارد
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('الاسم:', profile.name),
                            _buildInfoRow('العمر:', profile.age),
                            _buildInfoRow('الطول:', '${profile.height} سم'),
                            _buildInfoRow('الوزن:', '${profile.weight} كجم'),
                            _buildInfoRow('رقم الهاتف:', profile.phone),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  // زر تعديل الملف الشخصي
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(buttonPrimaryColor),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(data: profile),
                          ),
                        );
                      },
                      child: const Text(
                        'تعديل الملف الشخصي',
                        style: TextStyle(
                          color: kSecondryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: Text(
              'حدث خطأ في تحميل البيانات',
            ));
          }
        },
      ),
    );
  }

  // ويدجت لإظهار صف بيانات منسق
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
