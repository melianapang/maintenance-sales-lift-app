import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/approval/approval_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/approval/detail_approval_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/before_after_widget.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailApprovalViewParam {
  DetailApprovalViewParam({
    this.approvalData,
  });

  final ApprovalData? approvalData;
}

class DetailApprovalView extends StatefulWidget {
  const DetailApprovalView({
    required this.param,
    super.key,
  });

  final DetailApprovalViewParam param;

  @override
  State<DetailApprovalView> createState() => _DetailApprovalViewState();
}

class _DetailApprovalViewState extends State<DetailApprovalView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailApprovalViewModel(
        approvalData: widget.param.approvalData,
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (DetailApprovalViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Detail Permohonan",
            isBackEnabled: true,
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonWidget(
                  padding: const EdgeInsets.only(
                    right: 4.0,
                    left: 24.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  buttonType: ButtonType.secondary,
                  text: 'TOLAK',
                  onTap: () {
                    showDialogWidget(
                      context,
                      title: "Menolak Permohonan",
                      description:
                          "Apakahh anda yakin ingin menolak permintaan ini?",
                      positiveLabel: "Iya",
                      negativeLabel: "Tidak",
                      positiveCallback: () async {
                        await Navigator.maybePop(context);

                        buildLoadingDialog(context);
                        bool result = await model.requestChangeApprovalStatus(
                            isApprove: false);
                        Navigator.pop(context);

                        if (!result) {
                          showDialogWidget(
                            context,
                            title: "Menolak Permohonan",
                            description: model.errorMsg ??
                                "Data permintaan gagal diubah.",
                            isSuccessDialog: false,
                            positiveLabel: "OK",
                            positiveCallback: () {
                              model.resetErrorMsg();
                              Navigator.maybePop(context);
                            },
                          );
                          return;
                        }

                        showDialogWidget(
                          context,
                          title: "Menolak Permohonan",
                          isSuccessDialog: true,
                          description: "Permintaan telah ditolak.",
                          positiveLabel: "OK",
                          positiveCallback: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop(true);
                          },
                        );
                      },
                      negativeCallback: () {
                        Navigator.maybePop(context);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: ButtonWidget(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 4.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  buttonType: ButtonType.primary,
                  text: 'SETUJU',
                  onTap: () {
                    showDialogWidget(
                      context,
                      title: "Menyetujui Permohonan",
                      description:
                          "Apakahh anda yakin ingin menyetujui permintaan ini?",
                      positiveLabel: "Iya",
                      negativeLabel: "Tidak",
                      positiveCallback: () async {
                        await Navigator.maybePop(context);

                        buildLoadingDialog(context);
                        bool result = await model.requestChangeApprovalStatus(
                            isApprove: true);
                        Navigator.pop(context);

                        if (!result) {
                          showDialogWidget(
                            context,
                            title: "Menyetujui Permohonan",
                            description: model.errorMsg ??
                                "Data permintaan gagal diubah.",
                            isSuccessDialog: false,
                            positiveLabel: "OK",
                            positiveCallback: () {
                              model.resetErrorMsg();
                              Navigator.maybePop(context);
                            },
                          );
                          return;
                        }

                        showDialogWidget(
                          context,
                          title: "Menyetujui Permohonan",
                          description: "Permintaan telah disetujui.",
                          isSuccessDialog: true,
                          positiveLabel: "OK",
                          positiveCallback: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop(true);
                          },
                        );
                      },
                      negativeCallback: () {
                        Navigator.maybePop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Diajukan oleh",
                      style: buildTextStyle(
                        fontSize: 18,
                        fontColor: MyColors.lightBlack02,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                  Spacings.vert(12),
                  TextInput.disabled(
                    label: "Nama:",
                    text: model.approvalData?.userRequestName,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "No Telepon:",
                    text: model.approvalData?.userRequestPhoneNumber,
                  ),
                  Spacings.vert(32),
                  const Divider(
                    thickness: 0.5,
                    color: MyColors.lightBlack02,
                  ),
                  Spacings.vert(32),
                  ...buildBeforeAfterList(
                    oldContents: model.approvalData?.contentsOld,
                    newContents: model.approvalData?.contentsNew,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
