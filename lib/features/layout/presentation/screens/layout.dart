import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_category.dart';
import 'package:dr_fit/features/screens/PostsScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:dr_fit/features/profile/presentation/profile_screen.dart';
import 'package:dr_fit/features/screens/home.dart';
import 'package:dr_fit/features/screens/statistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DrFitLayout extends StatefulWidget {
  DrFitLayout({super.key});

  @override
  State<DrFitLayout> createState() => _DrFitLayoutState();
}

class _DrFitLayoutState extends State<DrFitLayout> {
  int currentIndex = 0;
  final List<Widget> screens = [
    Home(),
    BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          return StatisticsScreen(
            age: int.tryParse(profileState.profileData.age)!,
            weight: profileState.profileData.weight,
            height: profileState.profileData.height,
          );
        }
        return Center(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                textDirection: TextDirection.rtl,
                '     جاري التحميل..   ',
                style: TextStyle(
                    color: buttonPrimaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: context.height * .1,
              ),
              LoadingAnimationWidget.flickr(
                leftDotColor: buttonPrimaryColor,
                rightDotColor: bottomNavigationBar,
                size: 100,
              ),
            ],
          ),
        ));
      },
    ),
    PostsScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
    RecipeCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: screens[currentIndex],
      bottomNavigationBar: Stack(
        children: [
          // Gradient background behind the BottomNavigationBar
          Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  buttonPrimaryColor,
                  buttonSecondaryColor
                ], // Customize your colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // The actual BottomNavigationBar
          BottomNavigationBar(
            currentIndex: currentIndex,
            elevation: 0, // Remove shadow so gradient is clean
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Transparent to show gradient
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'الرئيسية'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'إحصائيات'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'مجتمعنا'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood_rounded), label: 'التغذية'),
            ],
          ),
        ],
      ),
    );
  }
}
