import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/onboarding/controller/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomProgressBar extends StatelessWidget {
  final int page;

  const CustomProgressBar({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5, top: (page == 0) ? 3 : 0),
            height: context.height * .01,
            width: context.width * .05,
            decoration: BoxDecoration(
              color: (page == 0) ? Colors.white : buttonPrimaryColor(context),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5, top: (page == 1) ? 3 : 0),
            height: context.height * .01,
            width: context.width * .05, // Adjust the width as needed
            decoration: BoxDecoration(
              color: (page == 1)
                  ? Colors.white
                  : buttonPrimaryColor(context), // Background color
              borderRadius: BorderRadius.circular(5.0),
              //border: Border.all(color: Colors.purple, width: 2.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10, top: (page == 2) ? 3 : 0),
            height: context.height * .01,
            width: context.width * .05, // Adjust the width as needed
            decoration: BoxDecoration(
              color: (page == 2)
                  ? Colors.white
                  : buttonPrimaryColor(context), // Background color
              borderRadius: BorderRadius.circular(5.0),
              //border: Border.all(color: Colors.purple, width: 2.0),
            ),
          ),
        ],
      ),
    );
  }
}
