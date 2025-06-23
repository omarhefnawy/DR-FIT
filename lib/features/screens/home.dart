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
import 'package:dr_fit/features/Favorite/FavoritesScreen.dart'; // New import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../near_gyms/gyms.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontScale = screenWidth < 360 ? 0.9 : 1.0;
    final double carouselHeight = screenHeight * 0.25;
    final double logoSize = screenWidth * 0.3;

    _pageController.addListener(() {
      _currentPage.value = _pageController.page?.round() ?? 0;
    });

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
          Icons.smart_toy_outlined,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : textColor(context),
          size: 30 * fontScale,
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
                  fontSize: 18 * fontScale,
                ),
              );
            }
            return Text(
              'أهلاً !',
              style: TextStyle(
                color: textColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 18 * fontScale,
              ),
            );
          },
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return PopupMenuButton<ThemeMode>(
                icon: Icon(Icons.color_lens, color: textColor(context)),
                onSelected: (mode) {
                  themeProvider.setThemeMode(mode);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: ThemeMode.light, child: Text("Light")),
                  const PopupMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                  const PopupMenuItem(value: ThemeMode.system, child: Text("System")),
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: textColor(context)),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(width: 5),
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
              const SizedBox(height: 10),
              // Features Carousel
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 600),
                child: SizedBox(
                  height: carouselHeight,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final features = [
                        {
                          'title': 'خطط تمارين مخصصة',
                          'description': 'تمارين مصممة لتناسب مستواك وأهدافك.',
                          'image': 'assets/images/onboarding1.png',
                          'icon': Icons.fitness_center,
                        },
                        {
                          'title': 'متابعة تقدمك',
                          'description': 'تابع إحصائياتك وتحسن أدائك يوميًا.',
                          'image': 'assets/images/onboarding2.png',
                          'icon': Icons.bar_chart,
                        },
                        {
                          'title': 'شات بوت ذكي',
                          'description': 'اسأل واستشر مدربك الافتراضي في أي وقت.',
                          'image': 'assets/images/splash.png',
                          'icon': Icons.smart_toy,
                        },
                      ];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  features[index]['image'] as String,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.3),
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      buttonPrimaryColor(context).withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      features[index]['icon']! as IconData,
                                      color: Colors.white,
                                      size: 30 * fontScale,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      features[index]['title'] as String,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18 * fontScale,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      features[index]['description'] as String,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14 * fontScale,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Dynamic Dots Indicator
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentPage, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: List.generate(
                      3,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index
                              ? buttonPrimaryColor(context)
                              : buttonPrimaryColor(context).withOpacity(0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Workout Cards
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 800),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 16) / 2;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        InkWell(
                          onTap: () {
                            navigateTo(context, FavoritesScreen());
                          },
                          child: SizedBox(
                            width: cardWidth,
                            child: WorkoutCard(
                              title: 'التمارين المفضلة',
                              imagePath: 'assets/images/home2.jpg',
                              icon: Icons.article,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context, ExercisesType());
                          },
                          child: SizedBox(
                            width: cardWidth,
                            child: WorkoutCard(
                              title: 'التمارين',
                              imagePath: 'assets/images/home1.png',
                              icon: Icons.search,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Nearby Gyms Prompt
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 1000),
                child: InkWell(
                  onTap: () {
                    navigateTo(context, const GymsScreen());
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonPrimaryColor(context),
                          buttonPrimaryColor(context).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30 * fontScale,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'شوف أقرب جيم ليك واتمرن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18 * fontScale,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ابحث عن أفضل الجيمات القريبة من موقعك الآن!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12 * fontScale,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'ابحث الآن',
                            style: TextStyle(
                              color: buttonPrimaryColor(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 12 * fontScale,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Logo Animation
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: Center(
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              buttonPrimaryColor(context),
                              buttonPrimaryColor(context).withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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