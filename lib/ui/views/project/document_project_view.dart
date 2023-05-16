import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/document_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:intl/intl.dart';

class DocumentProjectViewwParam {
  DocumentProjectViewwParam({
    this.projectData,
  });

  final ProjectData? projectData;
}

class DocumentProjectView extends StatefulWidget {
  const DocumentProjectView({
    super.key,
    required this.param,
  });

  final DocumentProjectViewwParam param;

  @override
  State<DocumentProjectView> createState() => _DocumentProjectViewState();
}

class _DocumentProjectViewState extends State<DocumentProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
        model: DocumentProjectViewModel(
          dioService: Provider.of<DioService>(context),
          downloadService: Provider.of<DownloadService>(context),
          projectData: widget.param.projectData,
        ),
        onModelReady: (DocumentProjectViewModel model) async {
          await model.initModel();
        },
        builder: (context, model, _) {
          return Scaffold(
            appBar: buildDefaultAppBar(
              context,
              title: "Dokumen Proyek",
              isBackEnabled: true,
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                right: 24.0,
                bottom: 24.0,
                left: 24.0,
              ),
              child: !model.busy
                  ? SingleChildScrollView(
                      child: model.projectData?.documents?.isNotEmpty == true ||
                              model.projectData?.documents == null
                          ? Column(
                              children: [
                                ..._buildDocumentList(model: model),
                              ],
                            )
                          : Text(
                              "Tidak ada dokumen untuk proyek ini.",
                              style: buildTextStyle(
                                fontSize: 24,
                                fontWeight: 600,
                                fontColor: MyColors.lightBlack02,
                              ),
                            ),
                    )
                  : Column(
                      children: [
                        buildLoadingPage(),
                      ],
                    ),
            ),
          );
        });
  }

  List<Widget> _buildDocumentList({
    required DocumentProjectViewModel model,
  }) {
    return [
      Spacings.vert(24),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          StringUtils.removeZeroWidthSpaces(
            "Klik salah satu daftar untuk mengunduh berkas.",
          ),
          textAlign: TextAlign.start,
          style: buildTextStyle(
            fontSize: 14,
            fontColor: MyColors.yellow02,
            fontWeight: 500,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Spacings.vert(24),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.projectData?.documents?.length ?? 0,
        separatorBuilder: (context, index) => const Divider(
          color: MyColors.lightBlack01,
          thickness: 0.4,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: !model.busy
                    ? () async {
                        if (model.projectData?.documents?[index].filePath
                                .isEmpty ==
                            true) return;

                        bool isGranted = await model.checkPermissions();
                        if (!isGranted) return;

                        buildLoadingDialog(context);
                        await model.downloadData(
                          index: index,
                        );
                        Navigator.pop(context);

                        showDialogWidget(
                          context,
                          title: "Bukti Dokument",
                          isSuccessDialog: model.errorMsg == null,
                          description: model.errorMsg == null
                              ? "Bukti Dokumen berhasil diunduh. Untuk menyimpan ke perangkat anda, Anda bisa menekan tombol unduh saat berkas berhasil dibuka."
                              : model.errorMsg ??
                                  "Gagal mengunduh berkas. Coba beberapa saat lagi.",
                          positiveLabel: "OK",
                          positiveCallback: () {
                            Navigator.maybePop(context);
                          },
                        );
                      }
                    : null,
                child: Text(
                  mappingCustomerFileTypeToString(
                    int.parse(
                      model.projectData?.documents?[index].fileType ?? "3",
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontWeight: 400,
                    fontColor: MyColors.blueLihatSelengkapnya,
                    isUnderlined: true,
                  ),
                ),
              ),
              Spacings.vert(6),
              Text(
                'Dibuat pada tanggal: ${DateTimeUtils.convertStringToOtherStringDateFormat(
                  date: model.projectData?.documents?[index].createdAt ??
                      DateTimeUtils.convertDateToString(
                        date: DateTime.now(),
                        formatter: DateFormat(
                          DateTimeUtils.DATE_FORMAT_2,
                        ),
                      ),
                  formattedString: DateTimeUtils.DATE_FORMAT_2,
                )}',
                textAlign: TextAlign.start,
                style: buildTextStyle(
                  fontSize: 12,
                  fontWeight: 400,
                  fontColor: MyColors.lightBlack02,
                ),
              ),
              Spacings.vert(8),
            ],
          );
        },
      ),
    ];
  }
}