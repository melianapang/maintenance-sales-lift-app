import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/detail_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailReminderViewParam {
  DetailReminderViewParam({
    this.reminderData,
  });

  final ReminderData? reminderData;
}

class DetailReminderView extends StatefulWidget {
  const DetailReminderView({
    required this.param,
    super.key,
  });

  final DetailReminderViewParam param;

  @override
  State<DetailReminderView> createState() => _DetailReminderViewState();
}

class _DetailReminderViewState extends State<DetailReminderView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailReminderViewModel(
        dioService: Provider.of<DioService>(context),
        reminderData: widget.param.reminderData,
      ),
      onModelReady: (DetailReminderViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: 'Data Pengingat',
            isBackEnabled: true,
          ),
          bottomNavigationBar: !model.busy &&
                  (model.isCanLinkToFollowUpData ||
                      model.isCanLinkToMaintenanceData)
              ? ButtonWidget.bottomSingleButton(
                  text: model.isCanLinkToFollowUpData
                      ? "Lihat Data Konfirmasi"
                      : "Lihat Data Pemeliharaan",
                  padding: EdgeInsets.only(
                    bottom: PaddingUtils.getBottomPadding(
                      context,
                      defaultPadding: 12,
                    ),
                    left: 24.0,
                    right: 24.0,
                  ),
                  buttonType: ButtonType.primary,
                  onTap: () {
                    if (model.isCanLinkToFollowUpData) {
                      Navigator.pushNamed(
                        context,
                        Routes.detailFollowUp,
                        arguments: DetailFollowUpViewParam(
                          projectId: model.reminderData?.projectId ?? "",
                          projectName: model.reminderData?.projectName ?? "",
                          customerName: model.followUpData?.customerName ?? "",
                          companyName: model.followUpData?.companyName ?? "",
                          salesOwnedId: model.followUpData?.salesOwnedId ?? "",
                        ),
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        Routes.detailMaintenance,
                        arguments: DetailMaintenanceViewParam(
                          maintenanceData: model.maintenanceData,
                        ),
                      );
                    }
                  },
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: !model.busy
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Spacings.vert(32),
                        Text(
                          model.reminderData?.projectName ?? "(Tanpa Proyek)",
                          style: buildTextStyle(
                            fontSize: 32,
                            fontWeight: 800,
                            fontColor: MyColors.yellow01,
                          ),
                        ),
                        Text(
                          model.reminderData?.description ?? "",
                          style: buildTextStyle(
                            fontSize: 20,
                            fontWeight: 400,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                        Spacings.vert(42),
                        TextInput.disabled(
                          label: "Tanggal",
                          text: model.reminderData?.reminderDate != null
                              ? DateTimeUtils
                                  .convertStringToOtherStringDateFormat(
                                  date: model.reminderData?.reminderDate ?? "",
                                  formattedString: DateTimeUtils.DATE_FORMAT_2,
                                )
                              : "",
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Waktu Pengingat",
                          text: model.reminderData?.reminderTime,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Catatan",
                          hintText: "Catatan pengingat anda.",
                          text: model.reminderData?.remindedNote,
                        ),
                        Spacings.vert(24),
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

  void _handleErrorDialog(
    BuildContext context,
    DetailReminderViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Data Pelanggan",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan Data Pelanggan. \n Coba beberappa saat lagi.",
      negativeLabel: "Ok",
      negativeCallback: () {
        model.resetErrorMsg();
        Navigator.pop(context);
      },
    );
  }
}
