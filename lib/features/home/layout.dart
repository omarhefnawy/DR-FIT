import 'package:dr_fit/core/network/api/body_part.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_type.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrFitLayout extends StatelessWidget {
  const DrFitLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'أهلا عمر!',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                Text(
                  'لقد حان الوقت لكي تخطط جدولك.',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 20),
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
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: bottomNavigationBar,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'الرئيسية'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'إحصائيات'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'التدريب'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'أنا'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.food_bank_outlined), label: 'التغذيه'),
            ],
          ),
        );
      },
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final IconData icon;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: bottomNavigationBar,
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 94.17,
            child: Image(
              image: AssetImage(imagePath),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
