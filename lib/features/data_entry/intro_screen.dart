import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/data_entry/weight_picker_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: context.height * .35,
            child: Image(
              image: NetworkImage(
                'https://s3-alpha-sig.figma.com/img/f073/bdf3/414abead49ad4f90e4339bbf62565c95?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bxEBGKmIRBftO8n2TXU3rfZbJ3gWUFjtxPgy6JhV0-XM4NSEEzQRhi38L0j4Rx3LMkC7DYvR-5M7zp5iKy0sGW8YQu-mBgsNUTY9hLceiTsJwrGmI93haJUXzrii2fAIL8NH9wEowXFmzDHaGZhvWe1X~5qGPonh7MPOvZTCKcCp6cIe7U~tl~T~t9j-q4glsualw1DFKjwigcsVMaVoggisO2CMxERMfjHnqaHTuVGuEjBAiWNJahQ9OHdAKAYUiBZlEKag4o7RajD6UqzIVFvjQWl31ey~B7Ca~RD1EeQfMOd9KWCiLS8VBeGGQ0eUBMXaBhpvfaQ8fBMwQRGYaw__',
              ),
              fit: BoxFit.cover,
            ),
          ),
          Spacer(),
          Text(
            '''الأستمرارية
هي مفتاح التطور
لا تتوقف''',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: context.width * 0.097222222,
              fontWeight: FontWeight.bold,
              color: buttonPrimaryColor,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: defaultButton(
              width: context.width * .444,
              function: () {
                navigateTo(context, WeightPickerScreen());
              },
              text: 'التالي',
              radius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
