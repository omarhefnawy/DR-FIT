import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_type.dart';
import 'package:dr_fit/features/home/presentation/widgets/post_card.dart';
import 'package:dr_fit/features/home/presentation/widgets/workout_card.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/presetation/screens/add_post.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:dr_fit/features/profile/presentation/profile_screen.dart';
import 'package:dr_fit/features/profile/presentation/profile_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrFitLayout extends StatefulWidget {
  DrFitLayout({super.key});

  @override
  State<DrFitLayout> createState() => _DrFitLayoutState();
}

class _DrFitLayoutState extends State<DrFitLayout> {
  @override
  void initState() {
    super.initState();
    // جلب البوستات عند فتح الصفحة
    context.read<PostsCubit>().fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Text(
                '! أهلا ${state.profileData.name}',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              );
            }
            return Text(
              'أهلا !',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            );
          },
        ),
        actions: [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر رفع بوست جديد
            TextButton(
              onPressed: () {
                navigateTo(context, AddPostScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.upload),
                  SizedBox(width: 5),
                  Text(
                    'u p l o a d P o s t',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // نص ترحيبي
            Text(
              'لقد حان الوقت لكي تخطط جدولك.',
              style: TextStyle(color: Colors.black54),
            ),

            SizedBox(height: 20),

            // زر بدء تمرين جديد
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: bottomNavigationBar,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Center(
                child: Text(
                  'ابدأ تمرين جديد',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 40),

            // بطاقات التمارين والروتين
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: WorkoutCard(
                    title: 'روتينك الخاص',
                    imagePath: 'assets/images/home1.png',
                    icon: Icons.article,
                  ),
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context, ExercisesType());
                  },
                  child: WorkoutCard(
                    title: 'التمارين',
                    imagePath: 'assets/images/home1.png',
                    icon: Icons.search,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // البوستات هتظهر هنا بشكل صحيح تحت workout card
            Expanded(
              child: BlocBuilder<PostsCubit, PostsStates>(
                builder: (context, state) {
                  if (state is PostsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PostsLoadedState) {
                    final posts = state.posts;
                    return ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return BlocBuilder<ProfileCubit, ProfileStates>(
                          builder: (context, profileState) {
                            String userName = '';
                            String uid = '';
                            bool isOwner = false;
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (profileState is ProfileLoaded) {
                              userName = profileState.profileData.name;
                              uid = profileState.profileData.uid;
                              //isOwner = post.uid == currentUser?.uid;
                            }
                            return PostCard(
                              userId: uid,
                              name: userName,
                              post: post,
                              isOwner: isOwner,
                            );
                          },
                        );
                      },
                    );
                  } else if (state is PostsFailState) {
                    return Center(
                      child: Text(
                        'حدث خطأ: ${state.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Center(child: Text('لا يوجد بوستات حتى الآن.'));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        onTap: (value) {
          if (value == 3) {
            final uid = FirebaseAuth.instance.currentUser;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(uid: uid!.uid),
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: bottomNavigationBar,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'إحصائيات'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'التدريب'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'أنا'),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined), label: 'التغذيه'),
        ],
      ),
    );
  }
}
