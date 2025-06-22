import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/core/utils/custom_measure.dart';
import 'package:dr_fit/features/data_entry/presentation/screens/height_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class WeightPickerScreen extends StatefulWidget {
  const WeightPickerScreen({super.key});

  @override
  WeightPickerState createState() => WeightPickerState();
}

class WeightPickerState extends State<WeightPickerScreen> {
  late WeightSliderController _controller;
  double currentWeight = 75;

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
      initialWeight: currentWeight,
      minWeight: 40,
      maxWeight: 300,
      interval: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor(context), // Light purple background.
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: 200,
        backgroundColor: PrimaryColor(context),
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
                  color: buttonPrimaryColor(context),
                  size: 20,
                ),
                Text(
                  'عودة',
                  style: TextStyle(
                    color: buttonPrimaryColor(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            'اختار الوزن',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: buttonPrimaryColor(context),
            ),
          ),
          Spacer(),
          Container(
            color: buttonPrimaryColor(context),
            child: customSlider(
                height: context.height * .1875,
                width: context.width * .3333,
                isVertical: false,
                controller: _controller,
                function: (value) {
                  setState(() {
                    currentWeight = value;
                  });
                }),
          ),
          SizedBox(
            height: context.height * .025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${currentWeight.toInt()}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: buttonPrimaryColor(context),
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
                  'kg',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black26,
                  ),
                ),
              ),
            ],
          ),

          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: defaultButton(
              function: () {
                CacheHelper.setData(key: 'dataSaved', value: true);
                navigateTo(
                    context, HeightPickerScreen(currentWeight: currentWeight));
              },
              text: 'التالي',
              radius: 20,
              width: context.width * .444, context: context,
            ),
          ),
        ],
      ),
    );
  }
}
