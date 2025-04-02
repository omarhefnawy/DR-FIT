import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_type.dart';
import 'package:dr_fit/features/layout/presentation/widgets/post_card.dart';
import 'package:dr_fit/features/layout/presentation/widgets/workout_card.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/presetation/screens/add_post.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _DrFitLayoutState();
}

class _DrFitLayoutState extends State<Home> {
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
                '${state.profileData.name}  أهلاً ',
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
          IconButton(
            color: Colors.black,
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر رفع بوست جديد
              TextButton(
                onPressed: () {
                  final state = context.read<ProfileCubit>().state;
                  if (state is ProfileLoaded) {
                    navigateTo(
                        context,
                        AddPostScreen(
                          userName: state.profileData.name,
                        ));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.upload,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'u p l o a d P o s t',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              // نص ترحيبي
              Text(
                textDirection: TextDirection.rtl,
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

              // البوستات
              BlocBuilder<PostsCubit, PostsStates>(
                builder: (context, state) {
                  if (state is PostsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PostsLoadedState) {
                    final posts = state.posts;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                            if (profileState is ProfileLoaded) {
                              userName = profileState.profileData.name;
                              uid = profileState.profileData.uid;
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
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد تسجيل الخروج'),
          content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: Text('لا', style: TextStyle(color: Colors.grey)),
            ),
            BlocListener<LoginCubit, LoginStates>(
              listener: (context, state) {
                if (state is LogOutState) {
                  Navigator.of(context).pop();
                  navigateAndFinish(context, LoginScreen());
                }
              },
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  navigateAndFinish(context, LoginScreen());
                },
                child: Text('نعم', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );
  }
}
