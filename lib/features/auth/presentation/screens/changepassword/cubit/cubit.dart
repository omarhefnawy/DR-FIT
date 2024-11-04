import 'package:dr_fit/features/auth/presentation/screens/changepassword/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates>{
  ChangePasswordCubit():super(ChangePasswordInitialState());
  static ChangePasswordCubit get(context)=>BlocProvider.of(context);
   IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  bool isConfirmPassword = true;
  bool isChecked = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }
  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    suffix =
        isConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }
}