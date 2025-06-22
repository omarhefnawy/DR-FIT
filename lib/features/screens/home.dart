import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/chatboot/screens/chat_screen.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_type.dart';
import 'package:dr_fit/features/layout/presentation/widgets/workout_card.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:dr_fit/features/Favorite/FavoritesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        child: Icon(Icons.auto_awesome),
      ),
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Text(
                '${state.profileData.name} ${_getGreetingMessage()}',
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
              Text(
                textDirection: TextDirection.rtl,
                'لقد حان الوقت لكي تخطط جدولك.',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 7,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.normal,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      buttonPrimaryColor,
                      buttonSecondaryColor,
                    ], // Replace with your gradient colors
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    transform: GradientRotation(
                      3,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Make button transparent
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
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(context, FavoritesScreen());
                    },
                    child: WorkoutCard(
                      title: 'التمارين المفضله',
                      imagePath: 'assets/images/home2.jpg',
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
            ],
          ),
        ),
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 18) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
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
                Navigator.of(context).pop();
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
