import 'package:dr_fit/core/utils/constants.dart';
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
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: bottomNavigationBar,
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 94.17,
            child: Image(
              image: AssetImage(imagePath),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            height: 5,
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
