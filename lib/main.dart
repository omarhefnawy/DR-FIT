import 'package:device_preview/device_preview.dart';
import 'package:dr_fit/bloc_observer.dart';
import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/core/utils/app_theme.dart';
import 'package:dr_fit/features/Favorite/cubit/favorite_cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/auth_page.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/controller/controller_translate/translate_cubit.dart';
import 'package:dr_fit/features/onboarding/controller/onboarding_cubit.dart';
import 'package:dr_fit/features/onboarding/view/page/onboarding_page.dart';
import 'package:dr_fit/features/posts/data/repo_imp/comment_repo_imp.dart';
import 'package:dr_fit/features/posts/data/repo_imp/posts_repo_imp.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/core/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/notification/local/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "keys.env");
  await Firebase.initializeApp(); // لازم يكون قبل استخدام FirebaseAuth
  await LocalNotificationService.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final postsRepo = PostsRepoImp();
  final commentRepo = CommentRepoImp();

  @override
  Widget build(BuildContext context) {
    final hasOnboarding = CacheHelper.getData(key: 'onboarding', defaultValue: false) as bool;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => ExerciseCubit()),
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => TranslateCubit()),
        BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (_) => RecipeCubit()..fetchHealthyRecipes()),
        BlocProvider(
          create: (_) => ProfileCubit()
            ..fetchData(uid: FirebaseAuth.instance.currentUser?.uid ?? ""),
        ),
        BlocProvider(
          create: (_) => PostsCubit(
            commentRepoImp: commentRepo,
            postsRepoImp: postsRepo,
          )..fetchAllPosts(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              home: hasOnboarding ? AuthPage() : const OnboardingPage(),
            );
          },
        ),
      ),
    );
  }
}
