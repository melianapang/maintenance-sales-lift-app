import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/app_constants/routes.dart';

class AfterSetReminderView extends StatefulWidget {
  const AfterSetReminderView({
    super.key,
  });

  @override
  State<AfterSetReminderView> createState() => _AfterSetReminderViewState();
}

class _AfterSetReminderViewState extends State<AfterSetReminderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      bottomNavigationBar: ButtonWidget.bottomSingleButton(
        buttonType: ButtonType.primary,
        padding: EdgeInsets.only(
          bottom: PaddingUtils.getBottomPadding(
            context,
            defaultPadding: 12,
          ),
          left: 24.0,
          right: 24.0,
        ),
        onTap: () {
          Navigator.maybePop(context);
        },
        text: 'OK',
      ),
      body: Container(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tetapkan Pengingat Berhasil.",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 32,
                fontWeight: 400,
                fontColor: MyColors.lightBlack01,
              ),
            ),
            Spacings.vert(32),
            const Icon(
              PhosphorIcons.checkCircleBold,
              size: 150,
              color: MyColors.yellow01,
            ),
            Spacings.vert(32),
            Text(
              "Anda akan menerima notifikasi pada hari tersebut.",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 20,
                fontWeight: 400,
                fontColor: MyColors.lightBlack01,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
