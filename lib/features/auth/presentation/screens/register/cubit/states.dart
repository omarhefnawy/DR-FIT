abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterLoadedState extends RegisterStates {}

class RegisterFailState extends RegisterStates {
  final String massege;
  RegisterFailState({required this.massege});
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}
