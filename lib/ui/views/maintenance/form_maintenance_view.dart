import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/snackbars_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/form_maintenance_view_model.dart';
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

class FormMaintenanceViewParam {
  FormMaintenanceViewParam({
    this.maintenanceData,
  });

  final MaintenanceData? maintenanceData;
}

class FormMaintenanceView extends StatefulWidget {
  const FormMaintenanceView({
    required this.param,
    super.key,
  });

  final FormMaintenanceViewParam param;

  @override
  State<FormMaintenanceView> createState() => _FormMaintenanceViewState();
}

class _FormMaintenanceViewState extends State<FormMaintenanceView> {
  final ScrollController buktiFotoController = ScrollController();
  final ScrollController buktiVideoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormMaintenanceViewModel>(
      model: FormMaintenanceViewModel(
        maintenanceData: widget.param.maintenanceData,
        dioService: Provider.of<DioService>(context),
        sharedPreferencesService:
            Provider.of<SharedPreferencesService>(context),
        gCloudService: Provider.of<GCloudService>(context),
      ),
      onModelReady: (FormMaintenanceViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Form Hasil Pemeliharaan",
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
              top: 24,
            ),
            onTap: () {
              showDialogWidget(
                context,
                title: "Form Hasil Pemeliharaan",
                description:
                    "Apakah anda yakin ingin mengubah data ${model.maintenanceData?.unitName} untuk Pemeliharaan pada tanggal ${DateTimeUtils.convertStringToOtherStringDateFormat(
                  date: model.maintenanceData?.scheduleDate ?? "",
                  formattedString: DateTimeUtils.DATE_FORMAT_2,
                )}? \n \n Dengan TANGGAL PEMELIHARAAN SELANJUTNYA, yaitu: ${DateTimeUtils.convertDateToString(
                  date: model.selectedNextMaintenanceDates.first,
                  formatter: DateFormat(
                    DateTimeUtils.DATE_FORMAT_2,
                  ),
                )}",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  buildLoadingDialog(context);
                  bool result = await model.requestSaveMaintenanceData();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Form Hasil Pemeliharaan",
                    isSuccessDialog: result,
                    description: result
                        ? "Data pemeliharaan telah ditambahkan"
                        : model.errorMsg ??
                            "Data pemeliharaan gagal ditambahkan",
                    positiveLabel: "Ok",
                    positiveCallback: () {
                      if (result) {
                        Navigator.of(context)
                          ..pop()
                          ..pop(true);
                        return;
                      }

                      model.resetErrorMsg();
                      Navigator.pop(context);
                    },
                  );
                },
                negativeCallback: () => Navigator.pop(context),
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
                  label: "Tanggal Pemeliharaan",
                  text: DateTimeUtils.convertStringToOtherStringDateFormat(
                    date: model.maintenanceData?.scheduleDate ?? "",
                    formattedString: DateTimeUtils.DATE_FORMAT_2,
                  ),
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Nama Pelanggan",
                  hintText: "Nama Pelanggan",
                  text: model.maintenanceData?.customerName,
                ),
                Spacings.vert(24),
                if (model.maintenanceData?.companyName?.isNotEmpty == true)
                  TextInput.disabled(
                    label: "Nama Perusahaan",
                    hintText: "Nama Perusahaan",
                    text: model.maintenanceData?.companyName,
                  ),
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bukti Foto",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                GalleryThumbnailWidget(
                  galleryData: model.getPhotosData(),
                  scrollController: buktiFotoController,
                  galleryType: GalleryType.PHOTO,
                  isCRUD: model.isEdit,
                  callbackCompressedFiles: (compressedFile, isCompressing) {
                    if (isCompressing) {
                      buildLoadingDialog(context);
                      return;
                    }

                    Navigator.pop(context);
                    if (compressedFile != null) {
                      model.addCompressedFile(compressedFile);
                    }
                    setState(() {});

                    //scroll to last index of bukti foto
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => buktiFotoController.animateTo(
                        buktiFotoController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      ),
                    );
                  },
                  callbackDeleteAddedGallery: (data) {
                    model.removeCompressedFile(data);

                    setState(() {});
                  },
                ),
                Spacings.vert(12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bukti Video",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                GalleryThumbnailWidget(
                  galleryData: model.getVideosData(),
                  scrollController: buktiVideoController,
                  galleryType: GalleryType.VIDEO,
                  isCRUD: model.isEdit,
                  callbackCompressedFiles: (compressedFile, isCompressing) {
                    if (model.getVideosData().length == 1) {
                      SnackbarUtils.showSimpleSnackbar(
                          text: 'Anda hanya bisa menambahkan 1 video saja');
                      return;
                    }

                    if (isCompressing) {
                      buildLoadingDialog(context);
                      return;
                    }

                    Navigator.pop(context);
                    if (compressedFile != null) {
                      model.addCompressedFile(compressedFile);

                      setState(() {});
                      //scroll to last index of bukti video
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
                    model.removeCompressedFile(data);

                    setState(() {});
                  },
                ),
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hasil Pemeliharaan",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(6),
                buildMenuChoices(
                  model.hasilMaintenanceOption,
                  (int value) {
                    model.setHasilKonfirmasi(value);
                  },
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Catatan",
                  controller: model.noteController,
                  hintText: "Tulis catatan disini..",
                  maxLines: 5,
                ),
                Spacings.vert(24),
                DatePickerWidget(
                  label: "Tanggal Pemeliharaan Selanjutnya",
                  isRangeCalendar: false,
                  selectedDates: model.selectedNextMaintenanceDates,
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
                    model.setSelectedNextMaintenanceDates([start]);
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
