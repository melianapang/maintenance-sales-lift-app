import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/add_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddUserViewModel(),
      onModelReady: (AddUserViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah User",
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
              bool result = model.saveData();
              if (result) Navigator.pushNamed(context, Routes.setPasswordUser);
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
                  label: "Nama",
                  hintText: "Nama User",
                  text: model.name,
                  onChangedListener: (text) {
                    model.setName(value: text);
                  },
                  errorText:
                      !model.isNameValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Peran",
                  hintText: "Admin/Sales/Teknisi",
                  text: model.role,
                  onChangedListener: (text) {
                    model.setRole(value: text);
                  },
                  errorText:
                      !model.isRoleValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Alamat",
                  hintText: "Alamat User",
                  text: model.address,
                  onChangedListener: (text) {
                    model.setAddress(value: text);
                  },
                  errorText:
                      !model.isAdressValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Kota",
                  hintText: "Surabaya",
                  text: model.city,
                  onChangedListener: (text) {
                    model.setCity(value: text);
                  },
                  errorText:
                      !model.isCityValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "No Telepon",
                  hintText: "081xxxxxxxxxx",
                  keyboardType: TextInputType.number,
                  text: model.phoneNumber,
                  onChangedListener: (text) {
                    model.setPhoneNumber(value: text);
                  },
                  errorText: !model.isPhoneNumberValid
                      ? "Kolom ini wajib diisi."
                      : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Email",
                  hintText: "user123@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  text: model.email,
                  onChangedListener: (text) {
                    model.setEmail(value: text);
                  },
                  errorText:
                      !model.isEmailValid ? "Kolom ini wajib diisi." : null,
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
