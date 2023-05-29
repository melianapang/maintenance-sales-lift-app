import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_maintenance_view.dart';

class AccordionListWidget extends StatefulWidget {
  const AccordionListWidget({
    super.key,
    required this.title,
    required this.description,
    required this.listChildren,
  });

  final String title;
  final String description;
  final List<String> listChildren;

  @override
  State<AccordionListWidget> createState() => _AccordionListWidgetState();
}

class _AccordionListWidgetState extends State<AccordionListWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController animController;
  late Animation<double> heightFactor;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      reverseDuration: const Duration(
        milliseconds: 300,
      ),
    );
    heightFactor = animController.drive(
      CurveTween(
        curve: Curves.easeIn,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: AnimatedBuilder(
            animation: animController.view,
            builder: (context, child) {
              return Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      isExpanded = !isExpanded;
                      if (isExpanded) {
                        animController.forward();
                      } else {
                        animController.reverse().then((value) {
                          if (!mounted) return;
                          setState(() {});
                        });
                      }
                      PageStorage.of(context)?.writeState(
                        context,
                        isExpanded,
                      );
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                StringUtils.removeZeroWidthSpaces(
                                  widget.title,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: buildTextStyle(
                                  fontColor: MyColors.white,
                                  fontSize: 18,
                                  fontWeight: 600,
                                ),
                              ),
                              Spacings.vert(2),
                              Text(
                                StringUtils.removeZeroWidthSpaces(
                                  widget.description,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: buildTextStyle(
                                  fontColor: MyColors.white,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ),
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
                            child: Icon(
                              !isExpanded
                                  ? PhosphorIcons.caretDownBold
                                  : PhosphorIcons.caretUpBold,
                              color: MyColors.darkBlack02,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacings.vert(16),
                  ClipRect(
                    child: Align(
                      heightFactor: heightFactor.value,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: widget.listChildren.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: MyColors.transparent,
                          height: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.detailMaintenance,
                                arguments: DetailMaintenanceViewParam(
                                    // maintenanceData: widget.listChildren[index],
                                    ),
                              );
                            },
                            child: Text(
                              StringUtils.removeZeroWidthSpaces(
                                widget.listChildren[index],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: buildTextStyle(
                                fontColor: MyColors.blueLihatSelengkapnya,
                                fontSize: 18,
                                fontWeight: 400,
                                isUnderlined: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
