import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

Widget buildNoDataFoundPage() {
  return Expanded(
    child: Center(
      child: Text(
        "Tidak ada data yang dapat ditampilkan.",
        textAlign: TextAlign.center,
        maxLines: 3,
        style: buildTextStyle(
          fontSize: 24,
          fontColor: MyColors.greyButtonBorder,
          fontWeight: 400,
        ),
      ),
    ),
  );
}
