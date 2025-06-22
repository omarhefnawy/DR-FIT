import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login_screen.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/register/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال رابط التفعيل إلى بريدك الإلكتروني'),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(Duration(seconds: 2), () {
                navigateAndFinish(context, LoginScreen());
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('حدث خطأ في إرسال رابط التفعيل'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<RegisterCubit>(context);
          return Scaffold(
            backgroundColor: PrimaryColor(context),
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
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 60),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            return null;
                          },
                          label: 'البريد الإلكتروني',
                          prefix: Icons.email,
                        ),
                        SizedBox(height: 15),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: cubit.isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          isPassword: cubit.isPassword,
                          suffixPressed: cubit.changePasswordVisibility,
                          onChange: (value) => cubit.checkPasswordStrength(value),
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            } else if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|:"<>?~`])[A-Za-z\d!@#$%^&*()_+{}|:"<>?~`]{8,}$')
                                .hasMatch(value)) {
                              return 'يجب أن تحتوي كلمة المرور على:\n- 8 أحرف على الأقل\n- حرف كبير وحرف صغير\n- رقم\n- رمز خاص (@\$!%*?&)';
                            }
                            return null;
                          },
                          label: 'كلمة المرور',
                          prefix: Icons.lock,
                        ),
                        PasswordStrengthIndicator(strength: cubit.passwordStrength),
                        SizedBox(height: 15),
                        defaultFormField(
                          controller: confirmPasswordController,
                          type: TextInputType.visiblePassword,
                          suffix: cubit.isConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          isPassword: cubit.isConfirmPassword,
                          suffixPressed: cubit.changeConfirmPasswordVisibility,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء تأكيد كلمة المرور';
                            } else if (value != passwordController.text) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          },
                          label: 'تأكيد كلمة المرور',
                          prefix: Icons.lock,
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                            text: 'تسجيل',
                            isUpperCase: true,
                            radius: 20, context: context,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('لديك حساب بالفعل؟'),
                            defaultTextButton(
                              function: () => navigateAndFinish(context, LoginScreen()),
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

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          ...List.generate(3, (index) => _buildBar(index)),
          SizedBox(width: 10),
          Text(
            _getStrengthText(),
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index) {
    return Expanded(
      child: Container(
        height: 5,
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: index < strength ? _getColor() : Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (strength) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStrengthText() {
    switch (strength) {
      case 0:
        return 'ضعيفة';
      case 1:
        return 'متوسطة';
      case 2:
      case 3:
        return 'قوية';
      default:
        return '';
    }
  }
}