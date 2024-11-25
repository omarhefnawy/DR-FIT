import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/onboarding/view/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LogOutState) {
            navigateAndFinish(context, LoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      cubit.signOut();
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: Center(
              child: Text("Welcome Home"),
            ),
          );
        },
      ),
    );
  }
}
