import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/export_data_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class ExportDataCustomerView extends StatefulWidget {
  const ExportDataCustomerView({super.key});

  @override
  State<ExportDataCustomerView> createState() => _ExportDataCustomerViewState();
}

class _ExportDataCustomerViewState extends State<ExportDataCustomerView> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ExportDataCustomerViewModel(
        downloadService: Provider.of<DownloadService>(context),
      ),
      onModelReady: (ExportDataCustomerViewModel model) async {
        await model.initModel();
        if (!model.isAllowedToOpenPage) Navigator.pop(context);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Export Customer Data",
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
                          showDialogWidget(context,
                              title: "Unduh Data",
                              description: model.errorMsg ??
                                  "Tidak dapat membuka berkas.",
                              isSuccessDialog: false,
                              positiveLabel: "Okay", positiveCallback: () {
                            model.resetErrorMsg();
                            Navigator.pop(context);
                          });
                        }
                      },
                    );
                  }
                : null,
            text: 'Unduh Data',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: PaddingUtils.getPadding(
                context,
                defaultPadding: 12,
              ),
              child: Column(
                children: [
                  Text(
                    "Tekan tombol 'Unduh Data' dibawah halaman ini untuk mengunduh data pelanggan,",
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
}
