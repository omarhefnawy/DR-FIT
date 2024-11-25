// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/onboarding/view/components/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetpasswordScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
            ),
            backgroundColor: kPrimaryColor,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return ' الرجاء ادخال البريد الالكترونى';
                            }
                            return null;
                          },
                          label: 'البريد الالكترونى',
                          prefix: Icons.email,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                var email = emailController.text.trim();
                                //here reset code
                                try {
                                  FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: email);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Check you Email sir password"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.pop(
                                        context); // Navigate back to the previous page
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("error sending reset password"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            text: 'reset',
                            isUpperCase: true,
                            radius: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
