import 'package:dr_fit/core/utils/constants.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
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
                            width: 360,
                            height: 360,
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
                                  height: 30,
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
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  width: 178.56,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
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
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  width: 178.56,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
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
      ),
    );
  }
}
