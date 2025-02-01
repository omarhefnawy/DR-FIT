import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/intro_screen.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  bool isChecked = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(LoginChangePasswordVisibilityState());
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginLoaded());
    } catch (e) {
      emit(LoginFail(massege: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      emit(LogOutState());
    } catch (e) {
      emit(LoginFail(massege: e.toString()));
    }
  }

  Future<void> signWithGoogle(BuildContext context) async {
    emit(GoogleInitial());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out first to ensure the user is prompted to choose an account.
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        emit(GoogleFailed(massege: "Sign-in canceled by user."));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(GoogleSuccess());
      navigateAndFinish(context, IntroScreen());
    } catch (e) {
      emit(GoogleFailed(massege: e.toString()));
    }
  }
}
