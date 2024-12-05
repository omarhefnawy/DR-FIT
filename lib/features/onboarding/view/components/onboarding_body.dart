import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/onboarding/controller/onboarding_cubit.dart';
import 'package:dr_fit/features/onboarding/view/components/custom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBody extends StatelessWidget {
  OnboardingBody({super.key});
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var cubit = OnboardingCubit();
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return PageView(
                controller: pageController,
                children: List.generate(
                  cubit.data.length,
                  (index) {
                    final item = cubit.data[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item.image,
                          height: context.height * 0.45,
                        ),
                        (item.title.toString().isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              )
                            : SizedBox(
                                height: context.height * 0.0375,
                              ),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        Spacer(),
                        CustomProgressBar(
                          page: index,
                        ),
                        Spacer(),
                        (index == 2)
                            ? SizedBox(
                                height: context.height / 12,
                                width: context.width * 0.496,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: MaterialButton(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    color: buttonPrimaryColor,
                                    onPressed: () {
                                      cubit.onGetStart(context);
                                    },
                                    elevation: 10,
                                    child: const Text(
                                      'ابدأ',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: context.height / 12,
                                width: context.width * 0.496,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: MaterialButton(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    color: buttonPrimaryColor,
                                    onPressed: () =>
                                        cubit.toNext(pageController),
                                    elevation: 10,
                                    child: const Text(
                                      'التالي',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
