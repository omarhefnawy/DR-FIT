import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginChangePasswordVisibilityState extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginLoaded extends LoginStates {}

class LogOutState extends LoginStates {}

class LoginFail extends LoginStates {
  final String massege;
  LoginFail({required this.massege});
}

class GoogleInitial extends LoginStates {}

class GoogleSuccess extends LoginStates {}

class GoogleFailed extends LoginStates {
  final String massege;
  GoogleFailed({required this.massege});
}
