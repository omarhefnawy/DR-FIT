import 'package:bloc/bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/features/auth/presentation/screens/login/login.dart';
import 'package:dr_fit/features/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static OnboardingCubit get(context) => BlocProvider.of(context);

  void toNext(pageController) {
    pageController
        .nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    )
        .then((value) {
      emit(OnboardingNextSuccessPage());
    }).catchError((error) {
      emit(OnboardingNextErrorPage());
    });
  }

  Future<void> onGetStart(BuildContext context) async {
    try {
      CacheHelper.setData(key: 'onboarding', value: true);
      if (CacheHelper.getData(key: 'onboarding')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        emit(OnboardingStartSuccessPage());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  List data = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: '''اهلا بيك في تطبيق
“AK Team”''',
      subtitle: '''تذكرتك لنظام رياضي 
وغذائي متكامل''',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: '',
      subtitle: '''استمتع بخاصية العداد اللي
 هيساعدك تراقب أوزانك
  وتطورك بشكل دوري''',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: '',
      subtitle: '''اختار من مطبخ صحي ولذيذ مليان
 وصفات متنوعة اللي يناسب
  نظامك الغذائي''',
    ),
  ];
}
