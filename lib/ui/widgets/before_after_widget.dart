import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class BeforeAfterWigdet extends StatelessWidget {
  const BeforeAfterWigdet({
    required this.titleBefore,
    required this.descriptionBefore,
    required this.titleAfter,
    required this.descriptionAfter,
    this.isChanged = false,
    super.key,
  });

  final String titleBefore;
  final String descriptionBefore;
  final String titleAfter;
  final String descriptionAfter;
  final bool isChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacings.vert(12),
                Text(
                  titleBefore,
                  textAlign: TextAlign.start,
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02.withOpacity(0.5),
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(4),
                Text(
                  descriptionBefore,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 400,
                  ),
                ),
              ],
            ),
          ),
          Spacings.horz(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacings.vert(12),
                Text(
                  titleAfter,
                  textAlign: TextAlign.start,
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor:
                        (isChanged ? MyColors.yellow01 : MyColors.lightBlack02)
                            .withOpacity(0.5),
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(4),
                Text(
                  descriptionAfter,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor:
                        isChanged ? MyColors.yellow01 : MyColors.lightBlack02,
                    fontWeight: 400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
