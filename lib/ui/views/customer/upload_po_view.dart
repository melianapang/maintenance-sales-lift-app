import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/upload_po_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class UploadPOView extends StatefulWidget {
  const UploadPOView({super.key});

  @override
  State<UploadPOView> createState() => _UploadPOViewState();
}

class _UploadPOViewState extends State<UploadPOView> {
  final ScrollController buktiFotoController = ScrollController();
  List<GalleryData> galleryData = [
    GalleryData(
      filepath:
          "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
      galleryType: GalleryType.PHOTO,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: UploadPOViewModel(),
      onModelReady: (UploadPOViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Form Unggah Berkas PO",
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
            onTap: () {
              showDialogWidget(
                context,
                title: "Tambah Bukti PO",
                description: "Form Bukti PO telah disimpan!",
                positiveLabel: "OK",
                positiveCallback: () {
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
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nomor Pelanggan",
                  hintText: "Nomor Pelanggan",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nama Pelanggan",
                  hintText: "Nama Pelanggan",
                ),
                Spacings.vert(24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bukti PO",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontWeight: 400,
                      fontColor: MyColors.darkBlue01,
                    ),
                  ),
                ),
                GalleryThumbnailWidget(
                  galleryData: galleryData,
                  galleryType: GalleryType.PHOTO,
                  scrollController: buktiFotoController,
                  callbackCompressedFiles: (compressedFile, isCompressing) {
                    if (isCompressing) {
                      buildLoadingDialog(context);
                      return;
                    }

                    Navigator.pop(context);
                    if (compressedFile != null) {
                      galleryData.add(compressedFile);

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
                    galleryData.remove(data);

                    setState(() {});
                  },
                ),
                Spacings.vert(24),
                TextInput.multiline(
                  onChangedListener: (text) {},
                  label: "Catatan",
                  minLines: 5,
                  maxLines: 5,
                  hintText: "Tulis keterangan disini...",
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
