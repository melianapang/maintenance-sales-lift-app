import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

Widget buildNoDataFoundPage() {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          'assets/lotties/no-data.json',
          repeat: true,
          width: 200,
          height: 200,
          alignment: Alignment.center,
        ),
        Text(
          "Tidak ada data yang dapat ditampilkan.",
          textAlign: TextAlign.center,
          maxLines: 3,
          style: buildTextStyle(
            fontSize: 24,
            fontColor: MyColors.greyButtonBorder,
            fontWeight: 400,
          ),
        ),
      ],
    ),
  );
}

List<Widget> buildNoDataFoundPart() {
  return [
    Spacings.vert(24),
    LottieBuilder.asset(
      'assets/lotties/no-data.json',
      repeat: true,
      width: 150,
      height: 150,
      alignment: Alignment.center,
    ),
    Text(
      "Tidak ada data yang dapat ditampilkan.",
      textAlign: TextAlign.center,
      maxLines: 3,
      style: buildTextStyle(
        fontSize: 16,
        fontColor: MyColors.greyButtonBorder,
        fontWeight: 400,
      ),
    ),
  ];
}
