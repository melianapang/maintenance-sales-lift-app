import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/add_pic_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class PicData {
  PicData({
    required this.name,
    required this.phoneNumber,
  });

  final String name;
  final String phoneNumber;
}

class AddPicProjectView extends StatefulWidget {
  const AddPicProjectView({super.key});

  @override
  State<AddPicProjectView> createState() => _AddPicProjectViewState();
}

class _AddPicProjectViewState extends State<AddPicProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddPicProjectViewModel(),
      onModelReady: (AddPicProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah PIC Proyek",
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
              model.sendDataBack(context);
            },
            text: 'Tambahkan PIC',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInput.editable(
                  label: "Nama PIC",
                  controller: model.namaPicController,
                  onChangedListener: model.onChangedName,
                  hintText: "Nama PIC Proyek",
                  errorText: model.isNameValid == false
                      ? "Wajib diisi dengan benar menggunakan huruf"
                      : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Nomor Telepon PIC",
                  controller: model.phoneNumberController,
                  hintText: "Nomor Telepon PIC",
                  keyboardType: TextInputType.phone,
                  errorText: model.isPhoneNumberValid == false
                      ? "Wajib diisi dengan benar menggunakan angka"
                      : null,
                  onChangedListener: model.onChangedPhoneNumber,
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
