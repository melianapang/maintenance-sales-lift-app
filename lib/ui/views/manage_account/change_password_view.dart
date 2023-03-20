import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/change_password/change_password_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController oldPwdController = TextEditingController();
  final TextEditingController newPwdController = TextEditingController();
  final TextEditingController confirmNewPwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModel<ChangePasswordViewModel>(
      model: ChangePasswordViewModel(),
      onModelReady: (ChangePasswordViewModel model) async {
        await model.initModel();
      },
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: MyColors.lightGreyBackground,
          appBar: buildDefaultAppBar(
            context,
            title: "Ubah Kata Sandi",
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
                    label: "Kata Sandi Lama",
                    onChangedListener: (text) {},
                    isPassword: !model.showOldPassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          model.setShowOldPassword(!model.showOldPassword),
                      child: Icon(
                        model.showOldPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi lama anda",
                    errorText: model.isValid == false
                        ? "Your username is wrong"
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Kata Sandi Baru",
                    onChangedListener: (text) {},
                    isPassword: !model.showNewPassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          model.setShowNewPassword(!model.showNewPassword),
                      child: Icon(
                        model.showNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi baru anda",
                    errorText: model.isValid == false
                        ? "Your username is wrong"
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    onChangedListener: (text) {},
                    label: "Konfirmasi Kata Sandi Baru",
                    isPassword: !model.showConfirmNewPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => model.setShowConfirmNewPassword(
                          !model.showConfirmNewPassword),
                      child: Icon(
                        model.showConfirmNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi baru anda",
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
