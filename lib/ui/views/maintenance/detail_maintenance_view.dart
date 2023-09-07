import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/detail_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_change_maintenance_date_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_delete_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/detail_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/form_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';
import 'package:intl/intl.dart';

class DetailMaintenanceViewParam {
  DetailMaintenanceViewParam({
    this.maintenanceData,
  });

  MaintenanceData? maintenanceData;
}

class DetailMaintenanceView extends StatefulWidget {
  DetailMaintenanceView({
    required this.param,
    super.key,
  });

  final DetailMaintenanceViewParam param;

  @override
  State<DetailMaintenanceView> createState() => _DetailMaintenanceViewState();
}

class _DetailMaintenanceViewState extends State<DetailMaintenanceView> {
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailMaintenanceViewModel(
        maintenanceData: widget.param.maintenanceData,
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
        navigationService: Provider.of<NavigationService>(context),
      ),
      onModelReady: (DetailMaintenanceViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Data Pemeliharaan",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
          ),
          floatingActionButton: _buildExtendedFAB(model),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 24.0,
              bottom: 24.0,
              left: 24.0,
            ),
            child: !model.busy
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Spacings.vert(20),
                        Text(
                          model.maintenanceData?.unitName ?? "",
                          style: buildTextStyle(
                            fontSize: 32,
                            fontWeight: 800,
                            fontColor: MyColors.yellow01,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            buildLoadingDialog(context);
                            bool isSucceed =
                                await model.requestGetProjectData();
                            Navigator.pop(context);

                            if (!isSucceed) {
                              showDialogWidget(
                                context,
                                title: "Data Proyek",
                                isSuccessDialog: false,
                                description: model.errorMsg ??
                                    "Gagal mendapatkan Data Proyek. \n Coba beberappa saat lagi.",
                                positiveLabel: "Okay",
                                positiveCallback: () => Navigator.pop(context),
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              Routes.detailProject,
                              arguments: DetailProjectViewParam(
                                projectData: model.projectData,
                                sourcePage: DetailProjectSourcePage
                                    .DetailMaintenancePage,
                              ),
                            ).then((value) async {
                              if (value == null) return;
                              if (value == true) {
                                await model.refreshPage();
                                model.setPreviousPageNeedRefresh(true);

                                _handleErrorDialog(context, model);
                              }
                            });
                          },
                          child: Text(
                            model.maintenanceData?.projectName ?? "",
                            style: buildTextStyle(
                              fontSize: 24,
                              fontWeight: 700,
                              fontColor: MyColors.blueLihatSelengkapnya,
                              isUnderlined: true,
                            ),
                          ),
                        ),
                        if (model.maintenanceData?.companyName?.isEmpty ==
                            false) ...[
                          Spacings.vert(4),
                          Text(
                            model.maintenanceData?.companyName ?? "",
                            style: buildTextStyle(
                              fontSize: 20,
                              fontWeight: 400,
                              fontColor: MyColors.lightBlack02,
                            ),
                          ),
                        ],
                        Spacings.vert(20),
                        StatusCardWidget(
                          cardType: model.statusCardType,
                          onTap: () {},
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Lokasi",
                          text: model.maintenanceData?.unitLocation,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Jadwal Pemeliharaan",
                          text: DateTimeUtils
                              .convertStringToOtherStringDateFormat(
                            date: model.maintenanceData?.scheduleDate ??
                                DateTimeUtils.convertDateToString(
                                  date: DateTime.now(),
                                  formatter: DateFormat(
                                    DateTimeUtils.DATE_FORMAT_3,
                                  ),
                                ),
                            formattedString: DateTimeUtils.DATE_FORMAT_2,
                          ),
                        ),
                        Spacings.vert(24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Riwayat Pemeliharaan",
                            style: buildTextStyle(
                              fontSize: 16,
                              fontColor: MyColors.yellow01,
                              fontWeight: 400,
                            ),
                          ),
                        ),
                        Spacings.vert(8),
                        if (model.timelineData.isNotEmpty)
                          TimelineWidget(
                            listTimeline: model.timelineData,
                          ),
                        if (model.timelineData.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Belum ada Riwayat Pemeliharaan untuk unit ini.",
                              style: buildTextStyle(
                                fontSize: 16,
                                fontColor: MyColors.lightBlack02.withOpacity(
                                  0.5,
                                ),
                                fontWeight: 300,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      buildLoadingPage(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildExtendedFAB(DetailMaintenanceViewModel model) {
    return SpeedDial(
      icon: PhosphorIcons.plusBold,
      activeIcon: PhosphorIcons.xBold,
      spacing: 3,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      dialRoot: (ctx, open, toggleChildren) {
        return FloatingButtonWidget(
          onTap: toggleChildren,
          icon: PhosphorIcons.squaresFourBold,
        );
      },
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(52.0, 52.0),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      renderOverlay: false,
      useRotationAnimation: true,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      children: [
        if (model.isAllowedToDeleteMaintenance) ...[
          SpeedDialChild(
            child: !model.isDialChildrenVisible
                ? const Icon(PhosphorIcons.trashBold)
                : null,
            backgroundColor: MyColors.yellow02,
            foregroundColor: MyColors.white,
            label: 'Hapus Pemeliharaan',
            labelBackgroundColor: MyColors.lightBlack01,
            labelShadow: [
              const BoxShadow(
                color: MyColors.transparent,
              ),
            ],
            labelStyle: buildTextStyle(
                fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.formDeleteMaintenance,
                arguments: FormDeleteMaintenanceViewParam(
                  maintenanceData: model.maintenanceData,
                ),
              );

              setState() {
                model.setDialChildrenVisible();
              }
            },
          ),
        ],
        if (model.isAllowedToChangeMaintenanceDate) ...[
          SpeedDialChild(
            child: !model.isDialChildrenVisible
                ? const Icon(PhosphorIcons.calendarBold)
                : null,
            backgroundColor: MyColors.yellow02,
            foregroundColor: MyColors.white,
            label: 'Ganti Tanggal Pemeliharaan',
            labelBackgroundColor: MyColors.lightBlack01,
            labelShadow: [
              const BoxShadow(
                color: MyColors.transparent,
              ),
            ],
            labelStyle: buildTextStyle(
                fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.formChangeMaintenanceDate,
                arguments: FormChangeMaintenanceDateViewParam(
                  maintenanceData: model.maintenanceData,
                ),
              ).then((value) {
                if (value == null) return;
                if (value == true) {
                  model.refreshPage();
                  model.setPreviousPageNeedRefresh(true);

                  _handleErrorDialog(context, model);
                }
              });

              setState() {
                model.setDialChildrenVisible();
              }
            },
          ),
        ],
        SpeedDialChild(
          child: !model.isDialChildrenVisible
              ? const Icon(PhosphorIcons.pencilSimpleLineBold)
              : null,
          backgroundColor: MyColors.yellow02,
          foregroundColor: MyColors.white,
          label: 'Buat Laporan Pemeliharaan',
          labelBackgroundColor: MyColors.lightBlack01,
          labelShadow: [
            const BoxShadow(
              color: MyColors.transparent,
            ),
          ],
          labelStyle: buildTextStyle(
              fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
          onTap: () {
            _awaitFormMaintenanceViewResult(context, viewModel: model);

            setState() {
              model.setDialChildrenVisible();
            }
          },
        ),
        SpeedDialChild(
          child: !model.isDialChildrenVisible
              ? const Icon(PhosphorIcons.bellBold)
              : null,
          backgroundColor: MyColors.yellow02,
          foregroundColor: MyColors.white,
          label: 'Jadwalkan Pengingat',
          labelBackgroundColor: MyColors.lightBlack01,
          labelShadow: [
            const BoxShadow(
              color: MyColors.transparent,
            ),
          ],
          labelStyle: buildTextStyle(
              fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.formSetReminder,
              arguments: FormSetReminderViewParam(
                source: FormSetReminderSource.MaintenancePage,
                maintenanceData: model.maintenanceData,
              ),
            );

            setState() {
              model.setDialChildrenVisible();
            }
          },
        ),
      ],
    );
  }

  void _awaitFormMaintenanceViewResult(
    BuildContext context, {
    required DetailMaintenanceViewModel viewModel,
  }) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.formMaintenance,
      arguments: FormMaintenanceViewParam(
        maintenanceData: viewModel.maintenanceData,
      ),
    );
    setState(() {
      if (result == null) return;
      viewModel.setPreviousPageNeedRefresh(true);
      viewModel.refreshPageAfterUpdateFormMaintenance(result as int);
    });
  }

  void _handleErrorDialog(
    BuildContext context,
    DetailMaintenanceViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Data Pemeliharaan",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan Data Pemeliharaan. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        await model.refreshPage();

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
