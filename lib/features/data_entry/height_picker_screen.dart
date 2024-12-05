import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/core/utils/custom_measure.dart';
import 'package:dr_fit/features/data_entry/information_screen.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class HeightPickerScreen extends StatefulWidget {
  const HeightPickerScreen({super.key});

  @override
  HeightPickerState createState() => HeightPickerState();
}

class HeightPickerState extends State<HeightPickerScreen> {
  late WeightSliderController _controller;
  double Height = 165; // Default selected height.

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
      initialWeight: Height,
      minWeight: 100,
      maxWeight: 300,
      interval: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, // Light purple background.
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: 200,
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: buttonPrimaryColor,
                  size: 20,
                ),
                Text(
                  'عودة',
                  style: TextStyle(
                    color: buttonPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'كم طولك؟',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: buttonPrimaryColor,
              ),
            ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${Height.toInt()}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: buttonPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 5,
                  ),
                  child: Text(
                    'CM',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black26,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.height * .03125),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: buttonPrimaryColor,
              ),
              width: context.width * .3056,
              height: context.height * .5,
              padding: EdgeInsets.all(12),
              child: customSlider(
                height: context.height * .5,
                width: context.width * .0556,
                controller: _controller,
                isVertical: true,
                function: (value) {
                  setState(() {
                    Height = value;
                  });
                },
              ),
            ),
            Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: defaultButton(
                function: () {
                  navigateTo(context, InformationScreen());
                },
                text: 'التالي',
                radius: 20,
                width: context.width * .444,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
