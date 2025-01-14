import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/export_data_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExportDataMaintenanceView extends StatefulWidget {
  const ExportDataMaintenanceView({super.key});

  @override
  State<ExportDataMaintenanceView> createState() =>
      _ExportDataMaintenanceViewState();
}

class _ExportDataMaintenanceViewState extends State<ExportDataMaintenanceView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ExportDataMaintenanceViewModel(
        dioService: Provider.of<DioService>(context),
        downloadService: Provider.of<DownloadService>(context),
      ),
      onModelReady: (ExportDataMaintenanceViewModel model) async {
        await model.initModel();

        if (!model.isAllowedToOpenPage) Navigator.pop(context);
        _handleErrorDialog(
          context,
          model,
        );
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Export Data Pemeliharaan",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget(
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: !model.busy
                ? () async {
                    buildLoadingDialog(context);
                    await model.requestExportData();
                    Navigator.pop(context);

                    showDialogWidget(
                      context,
                      title: "Unduh Data",
                      isSuccessDialog: true,
                      description:
                          "Unduh data berhasil. \n Anda bisa melihat berkasnya di folder Download perangkat anda. Atau dengan klik tombol dibawah ini.",
                      positiveLabel: "OK",
                      negativeLabel: "Lihat Data",
                      positiveCallback: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                      negativeCallback: () async {
                        bool result = await model.openExportedData();
                        Navigator.maybePop(context);

                        if (!result) {
                          showDialogWidget(
                            context,
                            title: "Unduh Data",
                            description:
                                model.errorMsg ?? "Tidak dapat membuka berkas.",
                            isSuccessDialog: false,
                            positiveLabel: "Okay",
                            positiveCallback: () {
                              model.resetErrorMsg();
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    );
                  }
                : null,
            text: 'Unduh Data',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  Text(
                    "Tekan tombol 'Unduh Data' dibawah halaman ini untuk mengunduh data pemeliharaan,",
                    textAlign: TextAlign.center,
                    style: buildTextStyle(
                      fontSize: 18,
                      fontColor: MyColors.lightBlack02,
                      fontWeight: 600,
                    ),
                  ),
                  Spacings.vert(32),
                  const Icon(
                    PhosphorIcons.arrowFatLinesDownBold,
                    size: 60,
                    color: MyColors.lightBlack02,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    ExportDataMaintenanceViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Export Data Pemeliharaan",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar log. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.requestGetAllProjects();
        Navigator.pop(context);

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
