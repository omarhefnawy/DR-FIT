import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/theme_provider.dart';
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
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonPrimaryColor(context),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: Icon(
          // استخدام icon مخصص للشات
          Icons.smart_toy_outlined,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white // على الوضع النهاري
              : textColor(context), // على الوضع الليلي
          size: 30,
        ),
      ),
      backgroundColor: PrimaryColor(context),
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Text(
                '${state.profileData.name} ${_getGreetingMessage()}',
                style: TextStyle(
                  color: textColor(context),
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Text(
              'أهلاً !',
              style: TextStyle(
                color: textColor(context),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        actions: [
          Icon(Icons.notifications, color: textColor(context)),
          SizedBox(width: 10),
          Icon(Icons.search, color: textColor(context)),
          IconButton(
            icon: Icon(Icons.logout, color: textColor(context)),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
         Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return PopupMenuButton<ThemeMode>(
      icon: Icon(Icons.color_lens),
      onSelected: (mode) {
        themeProvider.setThemeMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: ThemeMode.light, child: Text("Light")),
        PopupMenuItem(value: ThemeMode.dark, child: Text("Dark")),
        PopupMenuItem(value: ThemeMode.system, child: Text("System")),
      ],
    );
  },
),
 ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'لقد حان الوقت لكي تخطط جدولك.',
                style: TextStyle(color: textColor(context)),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
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
                      buttonPrimaryColor(context),
                      buttonPrimaryColor(context),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    transform: const GradientRotation(3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Center(
                    child: Text(
                      'ابدأ تمرين جديد',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(context, FavoritesScreen());
                    },
                    child: WorkoutCard(
                      title: 'التمارين المفضلة',
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
              const SizedBox(height: 20),
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
          backgroundColor: PrimaryColor(context),
          title: Text(
            'تأكيد تسجيل الخروج',
            style: TextStyle(color: textColor(context)),
          ),
          content: Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            style: TextStyle(color: textColor(context)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'لا',
                style: TextStyle(color: textColor(context)),
              ),
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
                child: const Text(
                  'نعم',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
