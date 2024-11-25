import 'package:dr_fit/TempHome.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
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
            return HomePage(); // Pass email or default string if null
          }
          return LoginScreen();
        },
      ),
    );
  }
}
