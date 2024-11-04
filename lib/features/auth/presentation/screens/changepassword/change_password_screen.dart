// ignore_for_file: must_be_immutable, use_key_in_widget_constructors


import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/auth/presentation/screens/changepassword/cubit/cubit.dart';
import 'package:dr_fit/features/auth/presentation/screens/changepassword/cubit/state.dart';
import 'package:dr_fit/features/onboarding/view/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
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
                          'اعادة تعيين كلمة المرور',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ChangePasswordCubit.get(context).isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {}
                          },
                          isPassword: ChangePasswordCubit.get(context).isPassword,
                          suffixPressed: ChangePasswordCubit.get(context).changePasswordVisibility,
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
                          height: 60,
                        ),
                        defaultFormField(
                          controller: confirmPasswordController,
                          type: TextInputType.visiblePassword,
                          suffix: ChangePasswordCubit.get(context).isConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {}
                          },
                          isPassword: ChangePasswordCubit.get(context).isConfirmPassword,
                          suffixPressed: ChangePasswordCubit.get(context).changeConfirmPasswordVisibility,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء ادخال كلمه المرور';
                            }
                            return null;
                          },
                          label: 'تاكيد كلمة المرور',
                          prefix: Icons.lock,
                        ),
                        SizedBox(
                          height: 150,
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
                            text: 'التالى',
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