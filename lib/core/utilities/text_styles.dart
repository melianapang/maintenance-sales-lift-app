import 'package:flutter/material.dart';

Map<int, FontWeight> weightToObject = {
  300: FontWeight.w300,
  400: FontWeight.w400,
  500: FontWeight.w500,
  600: FontWeight.w600,
  700: FontWeight.w700,
  800: FontWeight.w800,
  900: FontWeight.w900,
};

TextStyle buildTextStyle({
  required double fontSize,
  double? fontWeight,
  Color? fontColor,
  bool isUnderlined = false,
  bool isItalic = false,
}) {
  return TextStyle(
    fontFamily: "dmsans",
    fontSize: fontSize,
    fontWeight: weightToObject[fontWeight ?? 400],
    color: fontColor,
    decoration: isUnderlined ? TextDecoration.underline : null,
    fontStyle: isItalic ? FontStyle.italic : null,
  );
}
