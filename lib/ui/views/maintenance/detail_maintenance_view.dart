import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/detail_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_change_maintenance_date_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

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
  @override
  Widget build(BuildContext context) {
    final List<TimelineData> list1 = [
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
    ];

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
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.formMaintenance);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 24.0,
              bottom: 24.0,
              left: 24.0,
            ),
            child: SingleChildScrollView(
              child: !model.busy
                  ? Column(
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
                        Text(
                          "PT ABC JAYA",
                          style: buildTextStyle(
                            fontSize: 20,
                            fontWeight: 400,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                        Spacings.vert(35),
                        StatusCardWidget(
                          cardType: model.statusCardType,
                          onTap: () {},
                        ),
                        Spacings.vert(35),
                        TextInput.disabled(
                          label: "Lokasi",
                          text: model.maintenanceData?.unitLocation,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "PIC",
                          text: model.maintenanceData?.pic,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Jadwal Pemeliharaan Selanjutnya",
                          text: model.maintenanceData?.endMaintenance,
                        ),
                        if (model.isAllowedToDeleteNextMaintenance) ...[
                          Spacings.vert(8),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.formDeleteMaintenance,
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Hapus data Pemeliharaan selanjutnya',
                                style: buildTextStyle(
                                  fontSize: 12,
                                  fontWeight: 400,
                                  fontColor: MyColors.blueLihatSelengkapnya,
                                  isUnderlined: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (model.isAllowedToChangeNextMaintenanceDate) ...[
                          Spacings.vert(8),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.formChangeMaintenanceDate,
                                arguments: FormChangeMaintenanceDateViewParam(
                                  maintenanceData: model.maintenanceData,
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Ganti Tanggal Pemeliharaan selanjutnya',
                                style: buildTextStyle(
                                  fontSize: 12,
                                  fontWeight: 400,
                                  fontColor: MyColors.blueLihatSelengkapnya,
                                  isUnderlined: true,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                        TimelineWidget(
                          listTimeline: model.timelineData,
                        ),
                      ],
                    )
                  : buildLoadingPage(),
            ),
          ),
        );
      },
    );
  }
}
