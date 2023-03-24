import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

class SnackbarUtils {
  static void showSimpleSnackbar({required String text}) {
    var cancel = BotToast.showText(
      text: text,
      duration: const Duration(
        seconds: 3,
      ),
      borderRadius: BorderRadius.circular(10),
      contentColor: MyColors.lightBlack02,
      textStyle: buildTextStyle(
        fontSize: 13,
        fontColor: MyColors.darkBlack02,
      ),
    );
  }
}
