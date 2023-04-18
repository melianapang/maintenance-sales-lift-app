import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class BeforeAfterItem extends StatelessWidget {
  const BeforeAfterItem({
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

List<Widget> buildBeforeAfterList({
  Map<String, dynamic>? oldContents,
  Map<String, dynamic>? newContents,
}) {
  if (oldContents != null) {
    return [
      Row(
        children: [
          Expanded(
            child: Text(
              "Sebelum",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 20,
                fontColor: MyColors.lightBlack02,
                fontWeight: 800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Sesudah",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 20,
                fontColor: MyColors.lightBlack02,
                fontWeight: 800,
              ),
            ),
          ),
        ],
      ),
      Spacings.vert(12),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: newContents?.length ?? 0,
        separatorBuilder: (context, index) => const Divider(
          color: MyColors.lightBlack01,
          thickness: 0.4,
        ),
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> oldData = oldContents;

          final Map<String, dynamic> newData = newContents ?? {};

          return BeforeAfterItem(
            titleBefore: StringUtils.replaceUnderscoreToSpaceAndTitleCase(
              oldData.keys.toList()[index].toString(),
            ),
            descriptionBefore: StringUtils.replaceUnderscoreToSpaceAndTitleCase(
              oldData.values.toList()[index].toString(),
            ),
            titleAfter: StringUtils.replaceUnderscoreToSpaceAndTitleCase(
              newData.keys.toList()[index].toString(),
            ),
            descriptionAfter: StringUtils.replaceUnderscoreToSpaceAndTitleCase(
              newData.values.toList()[index].toString(),
            ),
            isChanged: StringUtils.isStringDifferent(
              oldData.values.toList()[index].toString(),
              newData.values.toList()[index].toString(),
            ),
          );
        },
      ),
    ];
  }

  return [
    Text(
      "Terbaru",
      textAlign: TextAlign.center,
      style: buildTextStyle(
        fontSize: 20,
        fontColor: MyColors.lightBlack02,
        fontWeight: 800,
      ),
    ),
    Spacings.vert(12),
    ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newContents?.length ?? 0,
      separatorBuilder: (context, index) => const Divider(
        color: MyColors.lightBlack01,
        thickness: 0.4,
      ),
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> newData = newContents ?? {};

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
                      StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                        newData.keys.toList()[index].toString(),
                      ),
                      textAlign: TextAlign.start,
                      style: buildTextStyle(
                        fontSize: 14,
                        fontColor: MyColors.lightBlack02.withOpacity(0.5),
                        fontWeight: 700,
                      ),
                    ),
                    Spacings.vert(4),
                    Text(
                      StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                        newData.values.toList()[index].toString(),
                      ),
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
            ],
          ),
        );
      },
    ),
  ];
}
