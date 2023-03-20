import 'package:flutter/material.dart';

class PaddingUtils {
  static double getBottomPadding(
    BuildContext context, {
    double defaultPadding = 8,
  }) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return bottomPadding > 0 ? bottomPadding : defaultPadding;
  }
}
