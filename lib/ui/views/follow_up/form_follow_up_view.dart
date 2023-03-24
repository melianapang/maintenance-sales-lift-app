import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/form_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class FormFollowUpView extends StatefulWidget {
  const FormFollowUpView({super.key});

  @override
  State<FormFollowUpView> createState() => _FormFollowUpViewState();
}

class _FormFollowUpViewState extends State<FormFollowUpView> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ScrollController buktiFotoController = ScrollController();

  List<GalleryData> galleryData = [];

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormFollowUpViewModel>(
      model: FormFollowUpViewModel(),
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
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
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
                    "Bukti PO",
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
                TextInput.multiline(
                  onChangedListener: (text) {},
                  label: "Catatan",
                  hintText: "Tulis catatan disini...",
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
