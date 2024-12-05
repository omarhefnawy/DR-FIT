import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

Widget customSlider({
  required controller,
  required function(double),
  required bool isVertical,
  required height,
  required width,
}) {
  return VerticalWeightSlider(
    controller: controller,
    decoration: const PointerDecoration(
      width: 120.0,
      largeColor: Colors.white,
      mediumColor: Colors.white,
      smallColor: Colors.white,
      gap: 30.0,
    ),
    indicator: Container(
      width: 120,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          3,
        ),
        color: Colors.yellow,
      ),
    ),
    height: height,
    isVertical: isVertical,
    diameterRatio: 200,
    haptic: Haptic.mediumImpact,
    onChanged: function,
  );
}
