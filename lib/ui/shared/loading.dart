import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

Widget buildLoadingSymbol() {
  return const Center(
    child: CircularProgressIndicator.adaptive(),
  );
}

void buildLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async =>
          false, // <-- Prevents dialog dismiss on press of back button.
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(
                'assets/lotties/lottieflow-loading.json',
                repeat: true,
                width: 80,
                height: 80,
                alignment: Alignment.center,
              ),
              Spacings.vert(12),
              Text(
                'Loading...',
                style: buildTextStyle(
                  fontSize: 17,
                  fontColor: MyColors.darkBlack02,
                  fontWeight: 600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
