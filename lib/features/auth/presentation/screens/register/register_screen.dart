// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, must_be_immutable

import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/states.dart';
import 'package:dr_fit/features/onboarding/view/components/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) async {
          if (state is RegisterFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.massege),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is RegisterLoadedState) {
            try {
              await FirebaseAuth.instance.currentUser
                  ?.sendEmailVerification(); // Send email verification
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Check your email for confirmation.'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to the main screen after showing the SnackBar
              Future.delayed(Duration(seconds: 2), () {
                navigateAndFinish(context, LoginScreen());
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error sending massegs'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = BlocProvider.of<RegisterCubit>(context);
          return Scaffold(
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
                          'البدء',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          height: 15,
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
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: RegisterCubit.get(context).isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {}
                          },
                          isPassword: RegisterCubit.get(context).isPassword,
                          suffixPressed: RegisterCubit.get(context)
                              .changePasswordVisibility,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء ادخال كلمه المرور';
                            }
                            return null;
                          },
                          label: 'كلمة المرور',
                          prefix: Icons.lock,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: confirmPasswordController,
                          type: TextInputType.visiblePassword,
                          suffix: RegisterCubit.get(context).isConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {}
                          },
                          isPassword:
                              RegisterCubit.get(context).isConfirmPassword,
                          suffixPressed: RegisterCubit.get(context)
                              .changeConfirmPasswordVisibility,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء تاكيد كلمه المرور';
                            }
                            return null;
                          },
                          label: 'تاكيد كلمه المرور',
                          prefix: Icons.lock,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                if (confirmPasswordController.text !=
                                    passwordController.text) {
                                  showToast(
                                      text:
                                          'The Password and ConfirmPassword is not Similar',
                                      state: ToastStates.ERROR);
                                  return;
                                } else {
                                  var email = emailController.text.trim();
                                  var password = passwordController.text.trim();
                                  cubit.signUp(
                                      email: email, password: password);
                                }
                              }
                            },
                            text: 'تسجيل',
                            isUpperCase: true,
                            radius: 20,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '  لديك حساب بالفعل؟',
                            ),
                            defaultTextButton(
                              function: () {
                                navigateAndFinish(context, LoginScreen());
                              },
                              text: 'تسجيل الدخول',
                            ),
                          ],
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
