import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/snackbars_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/form_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:intl/intl.dart';

class FormFollowUpViewParam {
  FormFollowUpViewParam({
    this.followUpId,
    this.nextFollowUpDate,
    this.projectData,
  });

  final String? followUpId;
  final String? nextFollowUpDate;
  final ProjectData? projectData;
}

class FormFollowUpView extends StatefulWidget {
  const FormFollowUpView({
    required this.param,
    super.key,
  });

  final FormFollowUpViewParam param;

  @override
  State<FormFollowUpView> createState() => _FormFollowUpViewState();
}

class _FormFollowUpViewState extends State<FormFollowUpView> {
  final ScrollController buktiFotoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormFollowUpViewModel>(
      model: FormFollowUpViewModel(
        projectData: widget.param.projectData,
        followUpId: widget.param.followUpId,
        nextFollowUpDate: widget.param.nextFollowUpDate,
        dioService: Provider.of<DioService>(context),
        gCloudService: Provider.of<GCloudService>(context),
        remoteConfigService: Provider.of<RemoteConfigService>(context),
      ),
      onModelReady: (FormFollowUpViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Form Hasil Konfirmasi",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
            buttonType: ButtonType.primary,
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            onTap: () async {
              showDialogWidget(
                context,
                title: "Laporan Hasil Konfirmasi",
                description:
                    "Apakah anda yakin ingin menyimpan data konfirmasi ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                negativeCallback: () => Navigator.pop(context),
                positiveCallback: () async {
                  Navigator.pop(context);

                  if (model.busy) return;

                  buildLoadingDialog(context);
                  bool result = await model.requestSaveFollowUpData();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Laporan Hasil Konfirmasi",
                    isSuccessDialog: result,
                    description: result
                        ? "Laporan berhasil disimpan"
                        : model.errorMsg ??
                            "Laporan gagal disimpan. Coba beberapa saat lagi.",
                    positiveLabel: "Okay",
                    positiveCallback: () {
                      if (!result) {
                        model.resetErrorMsg();
                        Navigator.pop(context);
                        return;
                      }

                      Navigator.of(context)
                        ..pop()
                        ..pop(true);
                    },
                  );
                },
              );
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                TextInput.disabled(
                  label: "Tanggal Konfirmasi",
                  hintText: "Tanggal Konfirmasi",
                  text: DateTimeUtils.convertStringToOtherStringDateFormat(
                    date: model.nextFollowUpDate ??
                        DateTimeUtils.convertDateToString(
                          date: DateTime.now(),
                          formatter: DateFormat(
                            DateTimeUtils.DATE_FORMAT_3,
                          ),
                        ),
                    formattedString: DateTimeUtils.DATE_FORMAT_2,
                  ),
                ),
                if (model.projectData?.projectName.isNotEmpty == true) ...[
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Nama Proyek",
                    hintText: "Nomor Proyek",
                    text: model.projectData?.projectName,
                  ),
                ],
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Nama Pelanggan",
                  hintText: "Nama Pelanggan",
                  text: model.projectData?.customerName,
                ),
                if (model.projectData?.companyName?.isNotEmpty == true) ...[
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Nama Perusahaan",
                    hintText: "Nama Perusahaan",
                    text: model.projectData?.companyName,
                  ),
                ],
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Foto",
                    style: buildTextStyle(
                      fontSize: 16,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                GalleryThumbnailWidget(
                  galleryData: model.galleryData,
                  galleryType: GalleryType.PHOTO,
                  isShowingAddGalleryWidget:
                      !model.isReachingMaxTotalGalleryData,
                  scrollController: buktiFotoController,
                  callbackCompressedFiles: (compressedFile, isCompressing) {
                    if (isCompressing) {
                      buildLoadingDialog(context);
                      return;
                    }

                    if (model.galleryData.length >= 10) {
                      SnackbarUtils.showSimpleSnackbar(
                          text: 'Anda hanya bisa menambahkan MAKS 10 foto.');
                      return;
                    }

                    Navigator.pop(context);
                    if (compressedFile != null) {
                      model.addNewGalleryData(compressedFile);
                      setState(() {});

                      //scroll to last index of bukti foto
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => buktiFotoController.animateTo(
                          buktiFotoController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                        ),
                      );
                    }
                  },
                  callbackDeleteAddedGallery: (data) {
                    if (model.galleryData.isEmpty) return;

                    model.galleryData.remove(data);

                    setState(() {});
                  },
                ),
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hasil Konfrimasi",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(6),
                buildMenuChoices(
                  model.hasilKonfirmasiOption,
                  (int value) {
                    model.setHasilKonfirmasi(value);
                  },
                ),
                Spacings.vert(24),
                TextInput.editable(
                  controller: model.noteController,
                  label: "Catatan",
                  hintText: "Tulis catatan disini...",
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                Spacings.vert(24),
                DatePickerWidget(
                  label: "Tanggal Konfirmasi Selanjutnya",
                  isRangeCalendar: false,
                  selectedDates: model.selectedNextFollowUpDates,
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
                    model.setSelectedNextFollowUpDates([start]);
                  },
                ),
                Spacings.vert(24),
              ],
            ),
          ),
        );
      },
    );
  }
}
