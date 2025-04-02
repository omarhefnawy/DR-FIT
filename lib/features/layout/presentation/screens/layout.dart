import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ أضف هذا
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:dr_fit/features/profile/presentation/profile_screen.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_view.dart';
import 'package:dr_fit/features/screens/Training.dart';
import 'package:dr_fit/features/screens/food.dart';
import 'package:dr_fit/features/screens/home.dart';
import 'package:dr_fit/features/screens/statistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        return const Center(child: CircularProgressIndicator());
      },
    ),
    Training(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
    Food(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 2,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: bottomNavigationBar,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'إحصائيات'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'التدريب'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'أنا'),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                navigateTo(context, RecipeView());
              },
              icon: Icon(Icons.fastfood_rounded),
            ),
            label: 'التغذيه',
          ),
        ],
      ),
    );
  }
}
