import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFE1EDFA);
  static const Color focusedBorderColor = Color(0xFFE9FE78);
  static const Color enabledBorderColor = Color(0xFFE1EDFA);
  static const Color buttonBackgroundColor = Color(0xFFE9FE78);
  static const Color buttonText = Color(0xFF06203B);
}

class AppBorders {
  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(color: AppColors.enabledBorderColor),
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(color: AppColors.focusedBorderColor),
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(color: AppColors.enabledBorderColor),
  );
}

class AppPadding {
  static const EdgeInsets inputPadding =
      EdgeInsets.only(left: 22.0, bottom: 14.0, top: 15.0, right: 20.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 14.0);
}
