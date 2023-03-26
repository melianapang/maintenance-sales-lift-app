import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/manage_account/change_password_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<ChangePasswordViewModel>(
      model: ChangePasswordViewModel(),
      onModelReady: (ChangePasswordViewModel model) async {
        await model.initModel();
      },
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
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
                    text: model.oldPassword,
                    onChangedListener: (text) {
                      model.setOldPassword(password: text);
                    },
                    isPassword: !model.showOldPassword,
                    maxLines: 1,
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
                        ? "Kata sandi lama anda salah."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Kata Sandi Baru",
                    text: model.newPassword,
                    onChangedListener: (text) {
                      model.setNewPassword(password: text);
                    },
                    isPassword: !model.showNewPassword,
                    maxLines: 1,
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
                        ? "Kata sandi anda tidak valid."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Konfirmasi Kata Sandi Baru",
                    text: model.confirmNewPassword,
                    onChangedListener: (text) {
                      model.setConfirmNewPassword(password: text);
                    },
                    isPassword: !model.showConfirmNewPassword,
                    maxLines: 1,
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
                        ? "Kaya sandi anda tidak sama."
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
