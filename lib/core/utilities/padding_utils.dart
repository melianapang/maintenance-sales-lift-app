import 'package:flutter/material.dart';

class PaddingUtils {
  static double getBottomPadding(
    BuildContext context, {
    double defaultPadding = 8,
  }) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return bottomPadding > 0 ? bottomPadding : defaultPadding;
  }

  static EdgeInsets getPadding(
    BuildContext context, {
    double defaultPadding = 8,
  }) {
    final double topPadding = MediaQuery.of(context).viewPadding.top;
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final double leftPadding = MediaQuery.of(context).viewPadding.left;
    final double rightPadding = MediaQuery.of(context).viewPadding.right;

    return EdgeInsets.only(
      top: topPadding > 0 ? topPadding : defaultPadding,
      bottom: bottomPadding > 0 ? bottomPadding : defaultPadding,
      left: leftPadding > 0 ? leftPadding : defaultPadding,
      right: rightPadding > 0 ? rightPadding : defaultPadding,
    );
  }
}
