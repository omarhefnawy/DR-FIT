import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/onboarding/controller/onboarding_cubit.dart';
import 'package:dr_fit/features/onboarding/view/components/onboarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        var cubit = OnboardingCubit();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor(context),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Text(
                        'تخطي',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style:  TextStyle(
                          color: buttonPrimaryColor(context),
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: buttonPrimaryColor(context),
                        size: 28,
                      ),
                    ],
                  ),
                  onTap: () {
                    cubit.onGetStart(context);
                  },
                ),
              ),
            ],
          ),
          backgroundColor: PrimaryColor(context),
          body: OnboardingBody(),
        );
      },
    );
  }
}
