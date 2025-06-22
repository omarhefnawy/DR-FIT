import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final IconData icon;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * .45,
      height: context.height * .23,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            buttonPrimaryColor(context),
            buttonSecondaryColor(context),
          ], // Replace with your gradient colors
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: GradientRotation(1),
        ),
        color: bottomNavBarColor(context),
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.height * .12,
            width: context.width * .45,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(
                imagePath,
              ),
            ),
          ),
          SizedBox(
            height: context.height * .02,
          ),
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(
            height: context.height * .02,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
