import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_result.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_maintenance_view.dart';

class AccordionListMaintenanceWidget extends StatefulWidget {
  const AccordionListMaintenanceWidget({
    super.key,
    required this.title,
    required this.isRedStatus,
    required this.isFilterOffOrFilterNotMaintenance,
    required this.listUnitsMaintenances,
    required this.refreshPageCallback,
  });

  final String title;
  final bool isRedStatus;
  final bool isFilterOffOrFilterNotMaintenance;
  final List<MaintenanceData> listUnitsMaintenances;
  final VoidCallback refreshPageCallback;

  @override
  State<AccordionListMaintenanceWidget> createState() =>
      _AccordionListMaintenanceWidgetState();
}

class _AccordionListMaintenanceWidgetState
    extends State<AccordionListMaintenanceWidget>
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
      color: getBackgroundProjectColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          19.0,
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 14,
            bottom: 14,
          ),
          child: AnimatedBuilder(
            animation: animController.view,
            builder: (context, child) {
              return Column(
                children: [
                  Spacings.vert(6),
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
                          child: Text(
                            StringUtils.removeZeroWidthSpaces(
                              widget.title,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: buildTextStyle(
                              fontColor: MyColors.white,
                              fontSize: 20,
                              fontWeight: 600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              !isExpanded
                                  ? PhosphorIcons.caretDownBold
                                  : PhosphorIcons.caretUpBold,
                              color: getBackgroundProjectColor(),
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacings.vert(12),
                  ClipRect(
                    child: Align(
                      heightFactor: heightFactor.value,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.listUnitsMaintenances.length,
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
                                  maintenanceData:
                                      widget.listUnitsMaintenances[index],
                                ),
                              ).then((value) {
                                if (value == null || value == false) return;
                                widget.refreshPageCallback;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: getBackgroundUnitColor(
                                    widget.listUnitsMaintenances[index]),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringUtils.removeZeroWidthSpaces(
                                      widget.listUnitsMaintenances[index]
                                          .unitName,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: buildTextStyle(
                                      fontColor: MyColors.white,
                                      fontSize: 18,
                                      fontWeight: 400,
                                      isUnderlined: true,
                                    ),
                                  ),
                                  Text(
                                    "${widget.isFilterOffOrFilterNotMaintenance ? "Status Terakhir" : "Status"}: ${mappingStringNumerictoString(
                                      widget.isFilterOffOrFilterNotMaintenance
                                          ? widget.listUnitsMaintenances[index]
                                                  .lastMaintenanceResult ??
                                              "0"
                                          : widget.listUnitsMaintenances[index]
                                              .maintenanceResult,
                                    )}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: buildTextStyle(
                                      fontColor: MyColors.white,
                                      fontSize: 16,
                                      fontWeight: 400,
                                    ),
                                  ),
                                  Text(
                                    StringUtils.removeZeroWidthSpaces(
                                      DateTimeUtils
                                          .convertStringToOtherStringDateFormat(
                                        date: widget
                                            .listUnitsMaintenances[index]
                                            .scheduleDate,
                                        formattedString:
                                            DateTimeUtils.DATE_FORMAT_2,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: buildTextStyle(
                                      fontColor: widget.isRedStatus ||
                                              widget
                                                      .listUnitsMaintenances[
                                                          index]
                                                      .maintenanceResult ==
                                                  "0"
                                          ? MyColors.white
                                          : MyColors.greenFontStatusCard,
                                      fontSize: 16,
                                      fontWeight: 400,
                                    ),
                                  ),
                                ],
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

  Color getBackgroundUnitColor(MaintenanceData item) {
    if (item.isBgRed == true) return MyColors.redFontStatusCard;
    if (widget.isFilterOffOrFilterNotMaintenance) {
      switch (item.lastMaintenanceResult) {
        case "1":
          return MyColors.redFontStatusCard;
        case "2":
          return MyColors.greenFontStatusCard;
        case "0":
        default:
          return MyColors.lightBlack01;
      }
    }

    switch (item.maintenanceResult) {
      case "1":
        return MyColors.redFontStatusCard;
      case "2":
        return MyColors.greenBackgroundMaintenanceUnitCard;
      case "0":
      default:
        return MyColors.lightBlack01;
    }
  }

  Color getBackgroundProjectColor() {
    if (widget.isRedStatus) return MyColors.redBackgroundMaintenanceCard;
    if (widget.isFilterOffOrFilterNotMaintenance) {
      switch (widget.listUnitsMaintenances.first.lastMaintenanceResult) {
        case "1":
          return MyColors.redBackgroundMaintenanceCard;
        case "2":
          return MyColors.green002;
        case "0":
        default:
          return MyColors.darkBlack02;
      }
    }

    switch (widget.listUnitsMaintenances.first.maintenanceResult) {
      case "1":
        return MyColors.redBackgroundMaintenanceCard;
      case "2":
        return MyColors.green002;
      case "0":
      default:
        return MyColors.darkBlack02;
    }
  }
}
