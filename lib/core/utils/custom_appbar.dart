import 'package:dr_fit/core/utils/constants.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(context) {
  return AppBar(
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
  );
}
