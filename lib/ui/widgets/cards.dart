import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

import '../../core/app_constants/colors.dart';

enum CardType { menu, list }

extension CardTypeStyleExt on CardType {
  static Map<CardType, Color> fontColors = <CardType, Color>{
    CardType.menu: MyColors.darkBlue02,
    CardType.list: MyColors.darkBlue01,
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
      shadowColor: MyColors.greyColor,
      color: MyColors.white,
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
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
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
      shadowColor: MyColors.greyColor,
      color: MyColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          19.0,
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: buildTextStyle(
                        fontColor: cardType.fontColor,
                        fontSize: titleSize ?? 20,
                        fontWeight: 800,
                      ),
                    ),
                    if (description != null) ...[
                      Spacings.vert(2),
                      Text(
                        description ?? "",
                        style: buildTextStyle(
                          fontColor: cardType.fontColor,
                          fontSize: desc2Size ?? 16,
                          fontWeight: 400,
                        ),
                      ),
                    ],
                    if (description2 != null) ...[
                      Spacings.vert(2),
                      Text(
                        description2 ?? "",
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
              const Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                    'assets/images/arrow_list.png',
                  ),
                  width: 80,
                  height: 80,
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
    return GestureDetector(
        onTap: onTap,
        child: cardType == CardType.menu ? _buildMenuCard() : _buildListCard());
  }
}
