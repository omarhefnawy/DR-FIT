import 'package:flutter/material.dart';

// ألوان الوضع الفاتح
const Color kLightPrimary = Color.fromRGBO(237, 233, 255, 1);
const Color kLightSecondary = Color.fromRGBO(255, 255, 255, 1);
const Color kLightButtonPrimary = Color.fromRGBO(10, 12, 60, 1);
const Color kLightButtonSecondary = Color.fromRGBO(27, 32, 162, 1);
const Color kLightBottomNavBar = Color.fromARGB(255, 13, 71, 161);
const Color kLightTextColor = Colors.black;

// ألوان الوضع الداكن
const Color kDarkPrimary = Color(0xFF121212);
const Color kDarkSecondary = Color(0xFF1E1E1E);
const Color kDarkButtonPrimary = Color(0xFFBB86FC);
const Color kDarkButtonSecondary = Color(0xFF03DAC6);
const Color kDarkBottomNavBar = Color(0xFF1A1A1A);
const Color kDarkTextColor = Colors.white;

// ديناميكية الألوان
Color PrimaryColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkPrimary : kLightPrimary;

Color secondaryColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkSecondary : kLightSecondary;

Color buttonPrimaryColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkButtonPrimary : kLightButtonPrimary;

Color buttonSecondaryColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkButtonSecondary : kLightButtonSecondary;

Color bottomNavBarColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkBottomNavBar : kLightBottomNavBar;

Color textColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? kDarkTextColor : kLightTextColor;

Color textFieldColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white // أبيض نقي للوضع الداكن
      : Colors.black; // أسود للوضع الفاتح
}
