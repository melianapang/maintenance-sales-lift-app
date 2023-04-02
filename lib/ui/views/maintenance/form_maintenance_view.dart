import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/snackbars_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/form_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class FormMaintenanceView extends StatefulWidget {
  const FormMaintenanceView({super.key});

  @override
  State<FormMaintenanceView> createState() => _FormMaintenanceViewState();
}

class _FormMaintenanceViewState extends State<FormMaintenanceView> {
  final ScrollController buktiFotoController = ScrollController();
  final ScrollController buktiVideoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormMaintenanceViewModel>(
      model: FormMaintenanceViewModel(),
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
            onTap: () {},
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                DatePickerWidget(
                  label: "Tanggal Pengingat",
                  isRangeCalendar: false,
                  selectedDates: model.selectedDates,
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
                    model.setSelectedDates([start]);
                  },
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Nomor Pelanggan",
                  hintText: "Nomor Pelanggan",
                  onChangedListener: (text) {},
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Nama Pelanggan",
                  hintText: "Nama Pelanggan",
                  onChangedListener: (text) {},
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Nama Perusahaan",
                  hintText: "Nama Perusahaan",
                  onChangedListener: (text) {},
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
                    "Hasil Maintenance",
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
                TextInput.multiline(
                  onChangedListener: (text) {},
                  label: "Catatan",
                  hintText: "Tulis catatan disini..",
                  maxLines: 5,
                  minLines: 5,
                ),
                Spacings.vert(24),
                if (model.getPhotosData().length > 0)
                  Image.file(
                    File(model.compressedFiles
                        .where((element) =>
                            element.galleryType == GalleryType.PHOTO)
                        .first
                        .filepath),
                    width: 500,
                    height: 500,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
