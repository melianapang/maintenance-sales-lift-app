import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/manage_account/edit_profile_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class EditProfileViewParam {
  EditProfileViewParam({
    this.profileData,
  });
  final ProfileData? profileData;
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    required this.param,
    super.key,
  });

  final EditProfileViewParam param;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: EditProfileViewModel(
        dioService: Provider.of<DioService>(context),
        profileData: widget.param.profileData,
      ),
      onModelReady: (EditProfileViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Edit Profile",
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
              if (result) Navigator.pushNamed(context, Routes.home);
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  TextInput.editable(
                    controller: model.namaLengkapController,
                    label: "Nama",
                    hintText: "Nama Lengkap",
                    keyboardType: TextInputType.name,
                    onChangedListener: model.onChangedName,
                    errorText:
                        !model.isNameValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.peranController,
                    label: "Peran",
                    hintText: "Admin/Sales/Teknisi",
                    onChangedListener: model.onChangedRole,
                    errorText:
                        !model.isRoleValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.phoneNumberController,
                    label: "Nomor Telepon",
                    hintText: "081xxxxxxxxxx",
                    keyboardType: TextInputType.number,
                    onChangedListener: model.onChangedPhoneNumber,
                    errorText: !model.isPhoneNumberValid
                        ? "Kolom ini wajib diisi."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.alamatController,
                    label: "Alamat",
                    hintText: "Alamat Lengkap",
                    keyboardType: TextInputType.streetAddress,
                    onChangedListener: model.onChangedAddress,
                    errorText:
                        !model.isAdressValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.kotaController,
                    label: "Kota",
                    hintText: "Kota",
                    keyboardType: TextInputType.text,
                    onChangedListener: model.onChangedCity,
                    errorText:
                        !model.isCityValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.emailController,
                    label: "Email",
                    hintText: "abc@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    onChangedListener: model.onChangedEmail,
                    errorText:
                        !model.isEmailValid ? "Kolom ini wajib diisi." : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
