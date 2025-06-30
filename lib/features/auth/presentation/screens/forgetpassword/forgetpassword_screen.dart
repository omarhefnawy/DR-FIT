// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/cubit/states.dart';
import 'package:dr_fit/core/utils/component.dart';
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
              backgroundColor: PrimaryColor(context),
            ),
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
                            function: () async {
                              if (formKey.currentState!.validate()) {
                                var email = emailController.text.trim();
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: email);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.pop(context);
                                  });
                                } catch (e) {
                                  String errorMessage = "حدث خطأ غير متوقع";
                                  if (e is FirebaseAuthException) {
                                    switch (e.code) {
                                      case 'invalid-email':
                                        errorMessage =
                                            "صيغة البريد الإلكتروني غير صحيحة";
                                        break;
                                      case 'user-not-found':
                                        errorMessage =
                                            "إذا كان البريد الإلكتروني مسجلاً، سيتم إرسال الرابط إليه";
                                        break; // لا تعرض أن البريد غير موجود لأسباب أمنية
                                      default:
                                        errorMessage =
                                            "خطأ في الإرسال: ${e.message}";
                                    }
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            background: Colors.blueAccent,
                            text: 'reset',
                            isUpperCase: true,
                            radius: 20, context: context,
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
