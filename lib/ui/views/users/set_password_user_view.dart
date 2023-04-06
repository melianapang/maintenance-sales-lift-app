import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/set_password_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

//set password for new user.
class SetPasswordUserView extends StatefulWidget {
  const SetPasswordUserView({super.key});

  @override
  State<SetPasswordUserView> createState() => _SetPasswordUserViewState();
}

class _SetPasswordUserViewState extends State<SetPasswordUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<SetPasswordViewUserModel>(
      model: SetPasswordViewUserModel(),
      onModelReady: (SetPasswordViewUserModel model) async {
        await model.initModel();
      },
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: 'Atur Password',
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
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
                    label: "Kata Sandi Pengguna Baru",
                    controller: model.newPasswordController,
                    maxLines: 1,
                    isPassword: !model.showNewPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => model.setShowNewPassword(),
                      child: Icon(
                        model.showNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi untuk pengguna baru",
                    errorText: model.isValid == false
                        ? "Your username is wrong"
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Konfirmasi Kata Sandi",
                    maxLines: 1,
                    controller: model.newConfirmPasswordController,
                    isPassword: !model.showConfirmNewPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => model.setShowConfirmNewPassword(),
                      child: Icon(
                        model.showConfirmNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan ulang kata sandi untuk pengguna baru",
                    errorText: model.isValid == false
                        ? "Your username is wrong"
                        : null,
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
