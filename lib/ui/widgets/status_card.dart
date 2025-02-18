import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

enum StatusCardType {
  //maintenance
  Pending,
  Confirmed,
  Canceled,
  //unit
  Normal,
  Defect,
  OnFix,
  //follow up
  Loss,
  Win,
  Hot,
  InProgress,
}

extension StatusCardTypeStyleExt on StatusCardType {
  static Map<StatusCardType, Color> backgroundColors = <StatusCardType, Color>{
    StatusCardType.Pending: MyColors.greyBackgroundStatusCard,
    StatusCardType.Confirmed: MyColors.greenBackgroundStatusCard,
    StatusCardType.Canceled: MyColors.redBackgroundStatusCard,
    StatusCardType.OnFix: MyColors.greyBackgroundStatusCard,
    StatusCardType.Normal: MyColors.greenBackgroundStatusCard,
    StatusCardType.Defect: MyColors.redBackgroundStatusCard,
    StatusCardType.Loss: MyColors.redBackgroundStatusCard,
    StatusCardType.Win: MyColors.greenBackgroundStatusCard,
    StatusCardType.Hot: MyColors.greenBackgroundStatusCard,
    StatusCardType.InProgress: MyColors.greyBackgroundStatusCard,
  };
  Color get backgroundColor => backgroundColors[this] ?? MyColors.lightGrey;

  static Map<StatusCardType, Color> fontColors = <StatusCardType, Color>{
    StatusCardType.Pending: MyColors.greyFontStatusCard,
    StatusCardType.Confirmed: MyColors.greenFontStatusCard,
    StatusCardType.Canceled: MyColors.redFontStatusCard,
    StatusCardType.OnFix: MyColors.greyFontStatusCard,
    StatusCardType.Normal: MyColors.greenFontStatusCard,
    StatusCardType.Defect: MyColors.redFontStatusCard,
    StatusCardType.Loss: MyColors.redFontStatusCard,
    StatusCardType.Win: MyColors.greenFontStatusCard,
    StatusCardType.Hot: MyColors.greenFontStatusCard,
    StatusCardType.InProgress: MyColors.greyFontStatusCard,
  };
  Color get fontColor => fontColors[this] ?? MyColors.greyFontStatusCard;

  static Map<StatusCardType, String> titles = <StatusCardType, String>{
    StatusCardType.Pending: "Pending",
    StatusCardType.Confirmed: "Berhasil",
    StatusCardType.Canceled: "Gagal / Batal",
    StatusCardType.Normal: "Normal",
    StatusCardType.Defect: "Bermasalah",
    StatusCardType.OnFix: "Sedang Diperbaiki",
    StatusCardType.Loss: "Loss",
    StatusCardType.Win: "Win",
    StatusCardType.Hot: "Hot",
    StatusCardType.InProgress: "In Progress",
  };
  String get title => titles[this] ?? "Pending";

  static Map<StatusCardType, PhosphorIconData> icons =
      <StatusCardType, PhosphorIconData>{
    StatusCardType.Pending: PhosphorIcons.clockClockwiseBold,
    StatusCardType.Confirmed: PhosphorIcons.checkCircleBold,
    StatusCardType.Canceled: PhosphorIcons.xCircleBold,
    StatusCardType.Normal: PhosphorIcons.checkCircleBold,
    StatusCardType.Defect: PhosphorIcons.xCircleBold,
    StatusCardType.OnFix: PhosphorIcons.clockClockwiseBold,
    StatusCardType.Loss: PhosphorIcons.xCircleBold,
    StatusCardType.Win: PhosphorIcons.checkCircleBold,
    StatusCardType.Hot: PhosphorIcons.clockClockwiseBold,
    StatusCardType.InProgress: PhosphorIcons.clockClockwiseBold,
  };
  PhosphorIconData get icon => icons[this] ?? PhosphorIcons.clockClockwiseBold;
}

class StatusCardWidget extends StatelessWidget {
  const StatusCardWidget({
    required this.cardType,
    required this.onTap,
  });

  final StatusCardType cardType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: cardType.backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              cardType.icon,
              color: cardType.fontColor,
              size: 32,
            ),
            Spacings.horz(10),
            Text(
              cardType.title,
              style: buildTextStyle(
                fontSize: 20,
                fontWeight: 800,
                fontColor: cardType.fontColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
