import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
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
      model: EditProfileViewModel(),
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
            onTap: () {},
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
                    label: "Nama",
                    text: "${widget.param.profileData?.username}",
                    hintText: "Nama Lengkap",
                    keyboardType: TextInputType.name,
                    onChangedListener: (text) {
                      print(text);
                    },
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Peran",
                    text: mappingRole(
                      widget.param.profileData?.role ?? Role.Admin,
                    ),
                    hintText: "Admin/Sales/Teknisi",
                    keyboardType: TextInputType.number,
                    onChangedListener: (text) {
                      print(text);
                    },
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Nomor Telepon",
                    text: widget.param.profileData?.phoneNumber,
                    hintText: "081xxxxxxxxxx",
                    keyboardType: TextInputType.number,
                    onChangedListener: (text) {
                      print(text);
                    },
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Alamat",
                    text: widget.param.profileData?.address,
                    hintText: "Alamat Lengkap",
                    keyboardType: TextInputType.streetAddress,
                    onChangedListener: (text) {
                      print(text);
                    },
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Kota",
                    text: widget.param.profileData?.city,
                    hintText: "Kota",
                    keyboardType: TextInputType.text,
                    onChangedListener: (text) {
                      print(text);
                    },
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Email",
                    text: widget.param.profileData?.email,
                    hintText: "abc@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    onChangedListener: (text) {
                      print(text);
                    },
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
