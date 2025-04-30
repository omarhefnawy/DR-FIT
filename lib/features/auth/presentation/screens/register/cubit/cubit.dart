import 'package:dr_fit/features/auth/presentation/screens/register/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  bool isConfirmPassword = true;
  int passwordStrength = 0;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    suffix = isConfirmPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*()_+{}|:"<>?~`]').hasMatch(password)) strength++;
    return (strength / 1.5).floor();
  }

  void checkPasswordStrength(String password) {
    final strength = _calculatePasswordStrength(password);
    passwordStrength = strength;
    emit(PasswordStrengthChangedState(strength));
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(RegisterLoadingState());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterLoadedState());
    } catch (e) {
      emit(RegisterFailState(massege: e.toString()));
    }
  }
}