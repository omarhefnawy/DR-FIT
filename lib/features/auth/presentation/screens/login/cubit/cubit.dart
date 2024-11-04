import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

  void changeCheckBoxSelected(bool click) {
    isChecked = click;
    emit(LoginChangeCheckBoxState());
  }
}
