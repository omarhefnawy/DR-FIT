import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/home/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_fit/features/profile/presentation/edit_profile.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:dr_fit/features/profile/presentation/profile_states.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';

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
    // تحميل بيانات المستخدم ومنشوراته
    context.read<ProfileCubit>().fetchData(uid: widget.uid);
    context.read<PostsCubit>().fetchUserPosts(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
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
        builder: (context, profileState) {
          if (profileState is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileState is ProfileLoaded) {
            final profile = profileState.profileData;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // صورة البروفايل
                  Center(
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 60,
                      backgroundImage: profile.img.isNotEmpty
                          ? NetworkImage(profile.img)
                          : const AssetImage('assets/logo/logo.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // معلومات المستخدم
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
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

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  // قسم المنشورات الخاصة بالمستخدم
                  BlocBuilder<PostsCubit, PostsStates>(
                    builder: (context, postsState) {
                      if (postsState is PostsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (postsState is PostsLoadedState) {
                        List<PostModel> userPosts = postsState.posts;

                        if (userPosts.isEmpty) {
                          return const Center(
                            child: Text(
                              'لا يوجد منشورات لهذا المستخدم.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: userPosts.length,
                            itemBuilder: (context, index) {
                              final post = userPosts[index];
                              return PostCard(
                                post: post,
                                name: profile.name,
                                isOwner: widget.uid == profile.uid,
                                userId: widget.uid,
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('حدث خطأ أثناء تحميل المنشورات'),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('حدث خطأ في تحميل البيانات'),
            );
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
