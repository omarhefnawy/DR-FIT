import 'package:dr_fit/bloc_observer.dart';
import 'package:dr_fit/core/network/local/cache_helper.dart';
<<<<<<< Updated upstream
=======
import 'package:dr_fit/features/auth/presentation/screens/auth_page.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/intro_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/weight_picker_screen.dart';
>>>>>>> Stashed changes
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/controller/controller_translate/translate_cubit.dart';
import 'package:dr_fit/features/home/layout.dart';
import 'package:dr_fit/features/onboarding/controller/onboarding_cubit.dart';
import 'package:dr_fit/features/onboarding/view/page/onboarding_page.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => ExerciseCubit()),
        BlocProvider(create: (_) => OnboardingCubit()),
<<<<<<< Updated upstream
        BlocProvider(create: (_) => TranslateCubit()),
=======
        BlocProvider(create: (_) => ProfileCubit()..fetchData(uid: uid.uid)),
>>>>>>> Stashed changes
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (CacheHelper.getData(key: 'onboarding', defaultValue: false)
                as bool)
            ? DrFitLayout()
            : OnboardingPage(),
      ),
    );
  }
}
