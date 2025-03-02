import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_type.dart';
import 'package:dr_fit/features/layout/presentation/widgets/post_card.dart';
import 'package:dr_fit/features/layout/presentation/widgets/workout_card.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/presetation/screens/add_post.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:dr_fit/features/profile/presentation/profile_screen.dart';
import 'package:dr_fit/features/profile/presentation/profile_states.dart';
import 'package:dr_fit/features/screens/Training.dart';
import 'package:dr_fit/features/screens/food.dart';
import 'package:dr_fit/features/screens/home.dart';
import 'package:dr_fit/features/screens/statistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrFitLayout extends StatefulWidget {
  DrFitLayout({super.key});

  @override
  State<DrFitLayout> createState() => _DrFitLayoutState();
}

class _DrFitLayoutState extends State<DrFitLayout> {
  int currentIndex=0;
  final List<Widget>screens=[
    Home(),
    Statistics(),
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
            currentIndex=index;
          });
         
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
