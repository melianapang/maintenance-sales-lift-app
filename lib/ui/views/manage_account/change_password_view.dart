import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/manage_account/change_password_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
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
      model: ChangePasswordViewModel(
        dioService: Provider.of<DioService>(context),
      ),
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
            onTap: () {
              bool isValid = model.isValidToRequest();
              if (!isValid) return;

              showDialogWidget(
                context,
                title: "Ubah Kata Sandi",
                description:
                    "Apakah anda yakin ingin mengubah kata sandi anda?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                negativeCallback: () {
                  Navigator.maybePop(context);
                },
                positiveCallback: () async {
                  await Navigator.maybePop(context);
                  bool isSuccess = await model.requestChangePassword();

                  showDialogWidget(
                    context,
                    title: "Ubah Kata Sandi",
                    description: isSuccess
                        ? "Perubahan kata sandi berhasil disimpan"
                        : "Perubahan kata sandi gagal disimpan",
                    isSuccessDialog: isSuccess,
                  );
                },
              );
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
                    controller: model.oldPasswordController,
                    label: "Kata Sandi Lama",
                    isPassword: !model.showOldPassword,
                    onChangedListener: model.onChangedOldPassword,
                    maxLines: 1,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          model.setShowOldPassword(!model.showOldPassword),
                      child: Icon(
                        model.showOldPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isOldPasswordValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi lama anda",
                    errorText: model.isOldPasswordValid == false
                        ? "Kata sandi lama anda salah."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.newPasswordController,
                    label: "Kata Sandi Baru",
                    isPassword: !model.showNewPassword,
                    onChangedListener: model.onChangedNewPassword,
                    maxLines: 1,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          model.setShowNewPassword(!model.showNewPassword),
                      child: Icon(
                        model.showNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isNewPasswordValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi baru anda",
                    errorText: model.isNewPasswordValid == false
                        ? "Kata sandi anda tidak valid."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.confirmPasswordController,
                    label: "Konfirmasi Kata Sandi Baru",
                    isPassword: !model.showConfirmNewPassword,
                    onChangedListener: model.onChangedConfirmNewPassword,
                    maxLines: 1,
                    suffixIcon: GestureDetector(
                      onTap: () => model.setShowConfirmNewPassword(
                          !model.showConfirmNewPassword),
                      child: Icon(
                        model.showConfirmNewPassword
                            ? PhosphorIcons.eyeClosed
                            : PhosphorIcons.eye,
                        color: model.isConfirmPasswordValid == false
                            ? Colors.redAccent
                            : MyColors.greyColor,
                      ),
                    ),
                    hintText: "Masukkan kata sandi baru anda",
                    errorText: model.isConfirmPasswordValid == false
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
