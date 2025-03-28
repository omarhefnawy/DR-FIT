import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/intro_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/weight_picker_screen.dart';
import 'package:dr_fit/features/layout/presentation/screens/layout.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),  // تأكد أن ProfileCubit يتم إنشاؤه
      child: Scaffold(
        body: BlocListener<ProfileCubit, ProfileStates>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              bool? check = CacheHelper.getData(key: 'dataSaved');
              Future.delayed(Duration(milliseconds: 300), () {
                if (check ?? false) {
                  if (state.profileData.name.isNotEmpty) {
                    navigateAndFinish(context, DrFitLayout());
                  } else {
                    navigateAndFinish(context, IntroScreen());
                  }
                } else {
                  navigateAndFinish(context, IntroScreen());
                }
              });
            } else if (state is ProfileFail) {
              print('❌ فشل تحميل البيانات: ${state.message}');
              navigateAndFinish(context, IntroScreen()); // في حالة الفشل، انتقل للشاشة الافتراضية
            }
          },
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String uid = snapshot.data!.uid;
                context.read<ProfileCubit>().fetchData(uid: uid); // ✅ تحميل البيانات بعد تسجيل الدخول
                return Center(child: CircularProgressIndicator());
              }
              return LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
