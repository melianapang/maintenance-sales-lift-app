import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/edit_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class EditUserView extends StatefulWidget {
  const EditUserView({super.key});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: EditUserViewModel(),
      onModelReady: (EditUserViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Edit Data User",
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
                title: "Mengubahh Data User",
                description: "Apakah anda yakin ingin mengubah data user ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                negativeCallback: () {
                  Navigator.maybePop(context);
                },
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  showDialogWidget(
                    context,
                    title: "Ubah Data User",
                    description: "Perubahan data user berhasil disimpan",
                    isSuccessDialog: true,
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
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nama",
                  hintText: "Nama User",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Peran",
                  hintText: "Admin/Sales/Teknisi",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Alamat",
                  hintText: "Alamat User",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Kota",
                  hintText: "Surabaya",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "No Telepon",
                  hintText: "081xxxxxxxxxx",
                  keyboardType: TextInputType.number,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Email",
                  hintText: "user123@gmail.com",
                  keyboardType: TextInputType.emailAddress,
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
