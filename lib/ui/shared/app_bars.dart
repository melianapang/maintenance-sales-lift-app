import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/app_constants/colors.dart';
import '../../core/utilities/text_styles.dart';

PreferredSizeWidget buildDefaultAppBar(
  BuildContext context, {
  required String title,
  bool centerTitle = true,
  bool isBackEnabled = false,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(
      title,
      style: buildTextStyle(
        fontSize: 16.0,
        fontWeight: 500,
        fontColor: MyColors.darkBlue01,
      ),
    ),
    backgroundColor: MyColors.white,
    centerTitle: centerTitle,
    elevation: 1,
    automaticallyImplyLeading: isBackEnabled,
    leading: isBackEnabled
        ? GestureDetector(
            onTap: () {
              Navigator.maybePop(context);
            },
            child: const Icon(
              PhosphorIcons.caretLeftBold,
              color: MyColors.darkBlue01,
              size: 16,
            ),
          )
        : null,
    actions: actions,
  );
}
