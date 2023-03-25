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

  List<GalleryData> galleryData = [
    GalleryData(
      filepath:
          "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://www.rollingstone.com/wp-content/uploads/2019/12/TaylorSwiftTimIngham.jpg?w=1581&h=1054&crop=1",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png/220px-191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://i.guim.co.uk/img/media/a48e88b98455a5b118d3c1d34870a1d3aaa1b5c6/0_41_3322_1994/master/3322.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=b95f25e4e31f132166006345fd87b5ae",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
      galleryType: GalleryType.PHOTO,
    ),
  ];

  List<GalleryData> videoData = [];

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormMaintenanceViewModel>(
      model: FormMaintenanceViewModel(),
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
                  galleryData: galleryData,
                  scrollController: buktiFotoController,
                  galleryType: GalleryType.PHOTO,
                  isCRUD: model.isEdit,
                  callbackGalleryPath: (path) {
                    galleryData.add(
                      GalleryData(
                        filepath: path,
                        galleryType: GalleryType.PHOTO,
                        isGalleryPicked: true,
                      ),
                    );
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
                    galleryData.remove(data);

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
                  galleryData: videoData,
                  scrollController: buktiVideoController,
                  galleryType: GalleryType.VIDEO,
                  isCRUD: model.isEdit,
                  callbackGalleryPath: (path) {
                    if (videoData.isNotEmpty) {
                      SnackbarUtils.showSimpleSnackbar(
                          text: 'Anda hanya bisa menambahkan 1 video saja');
                      return;
                    }

                    galleryData.add(
                      GalleryData(
                        filepath: path,
                        galleryType: GalleryType.PHOTO,
                        isGalleryPicked: true,
                      ),
                    );
                    setState(() {});

                    //scroll to last index of bukti video
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => buktiFotoController.animateTo(
                        buktiFotoController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      ),
                    );
                  },
                  callbackDeleteAddedGallery: (data) {
                    galleryData.remove(data);

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
              ],
            ),
          ),
        );
      },
    );
  }
}
