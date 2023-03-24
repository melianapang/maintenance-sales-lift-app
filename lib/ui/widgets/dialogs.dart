import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_constants/colors.dart';
import 'package:flutter_application_1/core/utilities/text_styles.dart';
import 'package:flutter_application_1/ui/shared/spacings.dart';
import 'package:flutter_application_1/ui/widgets/buttons.dart';

Future<dynamic> showGeneralBottomSheet({
  required BuildContext context,
  bool barrierDismissible = true,
  required Widget child,
  Color barrierColor = Colors.black,
  RouteSettings? routeSettings,
  String title = '',
  String? subtitle,
  bool centerTitle = false,
  bool showCloseButton = true,
  VoidCallback? onClose,
  double sizeToScreenRatio = 0.5,
  bool isFlexible = false,
}) async {
  final double bottomDangerousArea = MediaQuery.of(context).viewPadding.bottom;
  if (barrierColor == Colors.black) {
    barrierColor = barrierColor.withAlpha(116);
  }

  showGeneralDialog(
    context: context,
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          int sensitivity = 10;
          if (details.delta.dy > sensitivity ||
              details.delta.dy < -sensitivity) {
            onClose?.call();
            Navigator.of(context).pop();
          }
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: !isFlexible
                  ? MediaQuery.of(context).size.height * sizeToScreenRatio
                  : null,
              padding: const EdgeInsets.fromLTRB(
                24,
                35,
                24,
                0,
              ),
              decoration: const BoxDecoration(
                color: MyColors.darkBlack01,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: bottomDangerousArea > 0 ? 0 : 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            textAlign:
                                centerTitle ? TextAlign.center : TextAlign.left,
                            style: buildTextStyle(
                              fontSize: 24,
                              fontWeight: 600,
                              fontColor: MyColors.lightBlack02,
                            ),
                          ),
                        ),
                        if (showCloseButton)
                          GestureDetector(
                            onTap: () {
                              onClose?.call();
                              Navigator.maybePop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (subtitle != null) ...<Widget>[
                      Spacings.vert(4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: buildTextStyle(
                            fontSize: 12,
                            fontWeight: 400,
                            fontColor: MyColors.lightBlack001,
                          ),
                        ),
                      ),
                    ],
                    Spacings.vert(24),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    barrierColor: Colors.black.withOpacity(0.6),
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    useRootNavigator: true,
  );
}

void showDialogWidget(BuildContext context,
    {required String title,
    required String description,
    String? positiveLabel,
    String? negativeLabel,
    VoidCallback? positiveCallback,
    VoidCallback? negativeCallback}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: buildTextStyle(
                  fontSize: 20,
                  fontWeight: 500,
                  fontColor: MyColors.darkBlack02,
                ),
              ),
              Spacings.vert(20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: buildTextStyle(
                  fontSize: 16,
                  fontColor: MyColors.darkBlack02,
                ),
              ),
              Spacings.vert(38),
              if (negativeLabel != null) ...[
                Spacings.vert(10),
                ButtonWidget(
                  buttonType: ButtonType.secondary,
                  text: negativeLabel,
                  onTap: negativeCallback,
                ),
              ],
              if (positiveLabel != null) ...[
                Spacings.vert(10),
                ButtonWidget(
                  buttonType: ButtonType.primary,
                  text: positiveLabel,
                  onTap: positiveCallback,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error,
              ),
              Spacings.vert(4),
              const Text(
                "Wrong Username or Password",
                style: TextStyle(
                  fontFamily: "dmsans",
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
