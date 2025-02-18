import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/snackbars_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/upload_document_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class UploadDocumentViewParam {
  UploadDocumentViewParam({
    this.projectId,
  });

  final String? projectId;
}

class UploadDocumentView extends StatefulWidget {
  const UploadDocumentView({
    required this.param,
    super.key,
  });

  final UploadDocumentViewParam param;

  @override
  State<UploadDocumentView> createState() => _UploadDocumentViewState();
}

class _UploadDocumentViewState extends State<UploadDocumentView> {
  final ScrollController buktiFotoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: UploadDocumentViewModel(
        projectId: widget.param.projectId,
        dioService: Provider.of<DioService>(context),
        gCloudService: Provider.of<GCloudService>(context),
        remoteConfigService: Provider.of<RemoteConfigService>(context),
      ),
      onModelReady: (UploadDocumentViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Form Unggah Dokumen",
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
              buildLoadingDialog(context);
              bool isSucceed = await model.requestUploadDocumentData();
              Navigator.pop(context);

              showDialogWidget(
                context,
                title: "Unggah Dokumen",
                isSuccessDialog: isSucceed,
                description: isSucceed
                    ? "Dokumen telah disimpan!"
                    : model.errorMsg ?? "Dokumen gagal disimpan.",
                positiveLabel: "OK",
                positiveCallback: () {
                  if (isSucceed) {
                    Navigator.of(context)
                      ..pop()
                      ..pop(true);
                    return;
                  }

                  model.resetErrorMsg();
                  Navigator.maybePop(context);
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
                // TextInput.disabled(
                //   label: "Nomor Pelanggan",
                //   hintText: "Nomor Pelanggan",
                //   text: model.customerData?.customerNumber,
                // ),
                // Spacings.vert(24),
                // TextInput.disabled(
                //   label: "Nama Pelanggan",
                //   hintText: "Nama Pelanggan",
                //   text: model.customerData?.customerName,
                // ),
                // Spacings.vert(24),
                GestureDetector(
                  onTap: () {
                    _showTipeDokumenBottomDialog(
                      context,
                      model,
                      listMenu: model.tipeDokumentOption,
                      selectedMenu: model.selectedTipeDokumentOption,
                      setSelectedMenu: model.setTipeDokumen,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Tipe Dokumen",
                    text: model.tipeDokumentOption
                        .where((element) => element.isSelected)
                        .first
                        .title,
                    suffixIcon: const Icon(
                      PhosphorIcons.caretDownBold,
                      color: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bukti Dokumen",
                    style: buildTextStyle(
                      fontSize: 16,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "(Berkas yang diperbolehkan hanya PDF saja)",
                    style: buildTextStyle(
                      fontSize: 12,
                      fontWeight: 300,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                ),
                GalleryThumbnailWidget(
                  galleryData: model.galleryData,
                  galleryType: GalleryType.PDF,
                  scrollController: buktiFotoController,
                  callbackCompressedFiles: (compressedFile, isCompressing) {
                    if (model.galleryData.length == 1) {
                      SnackbarUtils.showSimpleSnackbar(
                          text: 'Anda hanya bisa menambahkan 1 file PDF saja');
                      return;
                    }

                    if (compressedFile != null) {
                      String ext = compressedFile.filepath.split('.').last;
                      if (ext.toLowerCase() != "pdf") {
                        SnackbarUtils.showSimpleSnackbar(
                          text:
                              "Jenis berkas yang diperbolehkan hanya PDF saja",
                        );
                        return;
                      }

                      model.galleryData.add(compressedFile);

                      setState(() {});
                      //scroll to last index of bukti pdf
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
                    model.galleryData.remove(data);

                    setState(() {});
                  },
                ),
                Spacings.vert(24),
                TextInput.editable(
                  controller: model.noteController,
                  label: "Catatan",
                  maxLines: 5,
                  hintText: "Tulis keterangan disini...",
                  keyboardType: TextInputType.multiline,
                ),
                Spacings.vert(24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTipeDokumenBottomDialog(
    BuildContext context,
    UploadDocumentViewModel model, {
    required List<FilterOption> listMenu,
    required int selectedMenu,
    required void Function({
      required int selectedMenu,
    }) setSelectedMenu,
  }) {
    final List<FilterOption> menuLocal = convertToNewList(listMenu);
    int menu = selectedMenu;

    showGeneralBottomSheet(
      context: context,
      title: 'Tipe Dokumen',
      isFlexible: true,
      showCloseButton: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMenuChoices(
                menuLocal,
                (int selectedIndex) {
                  menu = selectedIndex;
                  for (int i = 0; i < menuLocal.length; i++) {
                    if (i == selectedIndex) {
                      menuLocal[i].isSelected = true;
                      continue;
                    }

                    menuLocal[i].isSelected = false;
                  }
                  setState(() {});
                },
              ),
              Spacings.vert(32),
              ButtonWidget(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.large,
                text: "Terapkan",
                onTap: () {
                  setSelectedMenu(
                    selectedMenu: menu,
                  );
                  Navigator.maybePop(context);
                },
              )
            ],
          );
        },
      ),
    );
  }
}
