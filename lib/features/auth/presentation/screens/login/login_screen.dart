import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/forgetpassword/forgetpassword_screen.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/register_screen.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/intro_screen.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/layout/presentation/screens/layout.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginLoaded) {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                context
                    .read<ProfileCubit>()
                    .fetchData(uid: uid)
                    .then((profile) {
                  if (profile != null && profile.name.isNotEmpty) {
                    navigateAndFinish(context, DrFitLayout());
                  } else {
                    navigateAndFinish(context, IntroScreen());
                  }
                });
              }
            } else if (state is LoginFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.massege),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          // ✅ إضافة الـ builder المفقود
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Scaffold(
              backgroundColor: kLightPrimary,
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            '!مرحبا بعودتك',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 100),
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
                          SizedBox(height: 15),
                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: cubit.isPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {}
                            },
                            isPassword: cubit.isPassword,
                            suffixPressed: cubit.changePasswordVisibility,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء ادخال كلمه المرور';
                              }
                              return null;
                            },
                            label: 'كلمة المرور',
                            prefix: Icons.lock,
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    navigateTo(context, ForgetpasswordScreen());
                                  },
                                  child: Text('هل نسيت كلمه المرور؟'),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: defaultButton(
                              background: Colors.blueAccent[400],
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  cubit.signIn(
                                      email: email, password: password);
                                }
                              },
                              text: 'تسجيل الدخول',
                              isUpperCase: true,
                              radius: 20, context: context,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('تسجيل باستخدام',
                                    style: TextStyle(fontSize: 15)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 50,
                              left: 50,
                              top: 15,
                              bottom: 15,
                            ),
                            child: Container(
                              height: 50,
                              child: Row(
                                children: [
                                  Spacer(),
                                  IconButton(
                                    iconSize: 50,
                                    onPressed: () {
                                      cubit.signWithGoogle(context);
                                    },
                                    icon: Image(
                                      image: AssetImage(
                                        'assets/logo/google_logo.png',
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(' ليس لديك حساب؟'),
                              defaultTextButton(
                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                text: 'التسجيل',
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
        ));
  }
}
