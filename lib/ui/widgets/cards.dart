import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

import '../../core/app_constants/colors.dart';

enum CardType { menu, list, listWithIcon }

extension CardTypeStyleExt on CardType {
  static Map<CardType, Color> fontColors = <CardType, Color>{
    CardType.menu: MyColors.lightBlack02,
    CardType.list: MyColors.lightBlack02,
    CardType.listWithIcon: MyColors.lightBlack02,
  };
  Color get fontColor => fontColors[this] ?? Colors.transparent;
}

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    required this.cardType,
    required this.title,
    this.description,
    this.description2,
    this.icon,
    this.titleSize,
    this.descSize,
    this.desc2Size,
    this.onTap,
    super.key,
  });

  final CardType cardType;
  final String title;
  final String? description;
  final String? description2;
  final IconData? icon;
  final double? titleSize;
  final double? descSize;
  final double? desc2Size;
  final VoidCallback? onTap;

  Card _buildMenuCard() {
    return Card(
      elevation: 2,
      color: MyColors.darkBlack02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 14.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon ?? Icons.disabled_by_default,
                size: 32,
                color: cardType.fontColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Center(
                child: AutoSizeText(
                  title,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  minFontSize: 10,
                  maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  style: buildTextStyle(
                    fontColor: cardType.fontColor,
                    fontSize: titleSize ?? 10,
                    fontWeight: 400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildListCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 2,
      color: MyColors.darkBlack02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          19.0,
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            top: 14,
            bottom: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      StringUtils.removeZeroWidthSpaces(title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: buildTextStyle(
                        fontColor: cardType.fontColor,
                        fontSize: titleSize ?? 20,
                        fontWeight: 800,
                      ),
                    ),
                    if (description != null) ...[
                      Spacings.vert(2),
                      Text(
                        StringUtils.removeZeroWidthSpaces(description ?? ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: buildTextStyle(
                          fontColor: cardType.fontColor,
                          fontSize: descSize ?? 16,
                          fontWeight: 400,
                        ),
                      ),
                    ],
                    if (description2 != null) ...[
                      Spacings.vert(2),
                      Text(
                        StringUtils.removeZeroWidthSpaces(description2 ?? ""),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: buildTextStyle(
                          fontColor: cardType.fontColor,
                          fontSize: desc2Size ?? 16,
                          fontWeight: 400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 6,
                  ),
                  margin: const EdgeInsets.only(
                    right: 18,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.yellow01,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: cardType == CardType.list
                      ? const Icon(
                          PhosphorIcons.caretRightBold,
                          color: MyColors.darkBlack02,
                          size: 12,
                        )
                      : GestureDetector(
                          onTap: onTap,
                          child: Icon(
                            icon ?? PhosphorIcons.caretRightBold,
                            color: MyColors.darkBlack02,
                            size: 12,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cardType == CardType.listWithIcon) return _buildListCard();

    return GestureDetector(
        onTap: onTap,
        child: cardType == CardType.menu ? _buildMenuCard() : _buildListCard());
  }
}
