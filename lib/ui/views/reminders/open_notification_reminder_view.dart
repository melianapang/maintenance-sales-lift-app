import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/open_notification_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/form_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class OpenNotificationReminderViewParam {
  OpenNotificationReminderViewParam({
    this.date = "",
    this.time = "",
    this.description = "",
    this.note = "",
    this.reminderId = "",
  });

  final String date;
  final String time;
  final String description;
  final String note;
  final String reminderId;
}

class OpenNotificationReminderView extends StatelessWidget {
  OpenNotificationReminderView({
    required this.param,
    super.key,
  });

  OpenNotificationReminderViewParam param;

  @override
  Widget build(BuildContext context) {
    return ViewModel<OpenNotificationReminderViewModel>(
      model: OpenNotificationReminderViewModel(
        param: param,
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (OpenNotificationReminderViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                (route) => false,
              );
            }
            return true;
          },
          child: Scaffold(
            appBar: buildDefaultAppBar(
              context,
              title: "Pengingat",
              isBackEnabled: true,
            ),
            bottomNavigationBar: model.projectData != null
                ? ButtonWidget(
                    buttonType: ButtonType.primary,
                    text: "Buat Laporan Hasil Konfirmasi",
                    padding:
                        PaddingUtils.getPadding(context, defaultPadding: 24),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.formFollowUp,
                        arguments: FormFollowUpViewParam(
                          projectData: model.projectData,
                        ),
                      );
                    },
                  )
                : model.maintenanceData != null
                    ? ButtonWidget(
                        buttonType: ButtonType.primary,
                        text: "Buat Laporan Pemeliharaan",
                        padding: PaddingUtils.getPadding(context,
                            defaultPadding: 24),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.formMaintenance,
                            arguments: FormMaintenanceViewParam(
                              maintenanceData: model.maintenanceData,
                            ),
                          );
                        },
                      )
                    : null,
            body: !model.busy
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      24.0,
                    ),
                    child: Column(
                      children: [
                        TextInput.disabled(
                          label: "Tanggal Pengingat",
                          hintText: "Tanggal Pengingat",
                          text: model.param?.date,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Waktu Pengingat",
                          hintText: "Waktu Pengingat",
                          text: model.param?.time,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Deskripsi Pengingat",
                          hintText: "Tidak ada Deskripsi Pengingat",
                          text: model.param?.description,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Catatan",
                          hintText: "Tidak ada Catatan Pengingat",
                          text: model.param?.note,
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
}
