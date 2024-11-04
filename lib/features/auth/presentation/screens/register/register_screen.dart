// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, must_be_immutable



import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/states.dart';
import 'package:dr_fit/features/onboarding/view/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
 TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
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
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return ' الرجاء ادخال الاسم';
                            }
                            return null;
                          },
                          label: 'الاسم',
                          prefix: Icons.person,
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
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return ' الرجاء ادخال رقم الهانف';
                            }
                            return null;
                          },
                          label: 'رقم الهاتف',
                          prefix: Icons.email,
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
                          suffixPressed: RegisterCubit.get(context).changePasswordVisibility,
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
                          isPassword: RegisterCubit.get(context).isConfirmPassword,
                          suffixPressed: RegisterCubit.get(context).changeConfirmPasswordVisibility,
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
                                if(confirmPasswordController.text!=passwordController.text){
                                  showToast(text: 'The Password and ConfirmPassword is not Similar', state:  ToastStates.ERROR);
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
                        Row(
                          children: [
                            Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                               EdgeInsets.symmetric(horizontal: 8.0),
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
                                  onPressed: () {},
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
