import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/intro_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/weight_picker_screen.dart';
import 'package:dr_fit/features/home/presentation/screens/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Ensure snapshot data is not null and pass the user email
            dynamic check = CacheHelper.getData(key: 'dataSaved') ?? false;
            if (check) {
              return DrFitLayout();
            } else {
              return IntroScreen();
            }
            // Pass email or default string if null
          }
          return LoginScreen();
        },
      ),
    );
  }
}
