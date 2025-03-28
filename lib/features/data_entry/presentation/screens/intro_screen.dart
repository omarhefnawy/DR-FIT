import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/weight_picker_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: context.height * .4,
                child: Image.network(
                  'https://i.pinimg.com/originals/b6/53/4a/b6534a40c768214684c3362ca1bda9a3.png',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '''الأستمرارية
هي مفتاح التطور
لا تتوقف''',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: context.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: buttonPrimaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultButton(
                  width: context.width * .444,
                  function: () {
                    navigateTo(context, WeightPickerScreen());
                  },
                  text: 'التالي',
                  radius: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
