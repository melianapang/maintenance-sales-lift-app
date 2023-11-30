import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/update_apk/update_apk_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';

class UpdateApkViewParam {
  UpdateApkViewParam({
    this.minVersion,
    this.currentVersion,
  });

  final String? minVersion;
  final String? currentVersion;
}

class UpdateApkView extends StatefulWidget {
  const UpdateApkView({
    super.key,
    required this.param,
  });

  final UpdateApkViewParam param;

  @override
  State<UpdateApkView> createState() => _UpdateApkViewState();
}

class _UpdateApkViewState extends State<UpdateApkView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: UpdateApkViewModel(),
      onModelReady: (UpdateApkViewModel model) {
        model.initModel();
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: Padding(
              padding: PaddingUtils.getPadding(context, defaultPadding: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (model.isUpdatingApk == null)
                    _buildUpdateApkDialog(
                      updateNowOnTap: !model.busy ? model.updateApk : null,
                    ),
                  if (model.isUpdatingApk == true)
                    ..._buildDownloadingUpdatedApk(
                      progress: model.downloadApkEvent?.value,
                      status: model.downloadApkEvent?.status,
                    ),
                  if (model.isUpdatingApk == false)
                    ..._buildErrorUpdateApkDialog(
                      status: model.downloadApkEvent?.status,
                      tryAgainOnTap: !model.busy ? model.updateApk : null,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdateApkDialog({
    required VoidCallback? updateNowOnTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: MyColors.darkBlack02,
      color: MyColors.darkBlack02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Perbarui Aplikasi",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 24,
                fontWeight: 700,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(12),
            Text(
              "Aplikasi yang berjalan saat ini perlu diperbarui. Anda harus mengunduh aplikasi terbaru untuk melanjutkan aktivitas pada aplikasi ini.\n\n Versi anda saat ini: ${widget.param.currentVersion} \n Versi Minimum Aplikasi : ${widget.param.minVersion}",
              textAlign: TextAlign.center,
              style: buildTextStyle(
                fontSize: 16,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(32),
            ButtonWidget(
              buttonType: ButtonType.primary,
              buttonSize: ButtonSize.large,
              text: "Perbarui sekarang",
              onTap: updateNowOnTap,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDownloadingUpdatedApk({
    required String? progress,
    required OtaStatus? status,
  }) {
    if (progress == null || status == null) return [];

    String statusLabel = "";
    switch (status) {
      case OtaStatus.DOWNLOADING:
        statusLabel = "Mengunduh...";
        break;
      case OtaStatus.INSTALLING:
        statusLabel = "Memasang...";
        break;
      case OtaStatus.CHECKSUM_ERROR:
        statusLabel = "Oops! Gagal mengunduh (CORRUPTED FILE)";
        break;
      case OtaStatus.DOWNLOAD_ERROR:
        statusLabel = "Oops! Berkas tidak dapat diunduh. \n ($progress)";
        break;
      case OtaStatus.INTERNAL_ERROR:
        statusLabel = "Oops! Gagal mengunduh. Internal Error! \n ($progress)";
        break;
      case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
        statusLabel = "Oops! Tidak ada ijin. Gagal mengunduh.";
        break;
      case OtaStatus.ALREADY_RUNNING_ERROR:
      default:
    }

    return [
      Text(
        statusLabel,
        style: buildTextStyle(
          fontSize: 24,
          fontWeight: 500,
          fontColor: MyColors.lightBlack02,
        ),
      ),
      if (status == OtaStatus.DOWNLOADING ||
          status == OtaStatus.INSTALLING) ...[
        Spacings.vert(24),
        LinearProgressIndicator(
          value: status == OtaStatus.DOWNLOADING
              ? (double.tryParse(progress) != null
                  ? double.parse(progress) * 0.01
                  : null)
              : null,
          color: MyColors.yellow01,
          backgroundColor: MyColors.lightBlack02,
        ),
        Spacings.vert(12),
        if (status == OtaStatus.DOWNLOADING)
          Text(
            "$progress%",
            style: buildTextStyle(
              fontSize: 24,
              fontWeight: 500,
              fontColor: MyColors.lightBlack02,
            ),
          ),
      ],
    ];
  }

  List<Widget> _buildErrorUpdateApkDialog({
    required OtaStatus? status,
    required VoidCallback? tryAgainOnTap,
  }) {
    return [
      Text(
        status.toString(),
        style: buildTextStyle(
          fontSize: 24,
          fontWeight: 500,
          fontColor: MyColors.lightBlack02,
        ),
      ),
      Spacings.vert(24),
      ButtonWidget(
        buttonType: ButtonType.primary,
        text: "Coba Lagi",
        onTap: tryAgainOnTap,
      ),
    ];
  }
}
