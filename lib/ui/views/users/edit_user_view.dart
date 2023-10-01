import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/edit_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class EditUserViewParam {
  EditUserViewParam({
    this.userData,
  });

  UserData? userData;
}

class EditUserView extends StatefulWidget {
  const EditUserView({
    required this.param,
    super.key,
  });

  final EditUserViewParam param;

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: EditUserViewModel(
        userData: widget.param.userData,
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
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

                  buildLoadingDialog(context);
                  bool isSucceed = await model.requestEditUser();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Ubah Data User",
                    description: isSucceed
                        ? "Perubahan data user berhasil disimpan"
                        : model.errorMsg ??
                            "Perubahan data user gagal disimpan",
                    isSuccessDialog: isSucceed,
                    positiveLabel: "OK",
                    positiveCallback: () {
                      if (isSucceed) {
                        Navigator.of(context)
                          ..pop()
                          ..pop(true);
                        return;
                      }

                      model.resetErrorMsg();
                      Navigator.maybePop(context);
                    },
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
                  label: "Nama",
                  hintText: "Nama User",
                  controller: model.nameController,
                  onChangedListener: model.onChangedName,
                  errorText:
                      !model.isNameValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                if (model.isUserAllowedToChangeRole) ...[
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
                        listMenu: model.roleOptions,
                        selectedMenu: model.selectedRoleOption,
                        setSelectedMenu: model.setSelectedRole,
                      );
                    },
                    child: TextInput.disabled(
                      label: "Peran",
                      text: model.roleOptions
                          .where((element) => element.isSelected)
                          .first
                          .title,
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.lightBlack02,
                      ),
                    ),
                  ),
                  Spacings.vert(24),
                ],
                TextInput.editable(
                  label: "Alamat",
                  hintText: "Alamat User",
                  controller: model.addressController,
                  onChangedListener: model.onChangedAddress,
                  errorText:
                      !model.isAdressValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Kota",
                  hintText: "Surabaya",
                  controller: model.cityController,
                  onChangedListener: model.onChangedCity,
                  errorText:
                      !model.isCityValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "No Telepon",
                  hintText: "081xxxxxxxxxx",
                  keyboardType: TextInputType.number,
                  controller: model.phoneNumberController,
                  onChangedListener: model.onChangedPhoneNumber,
                  errorText: !model.isPhoneNumberValid
                      ? "Kolom ini wajib diisi."
                      : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Email",
                  hintText: "user123@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  controller: model.emailController,
                  onChangedListener: model.onChangedEmail,
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

  void _showBottomDialog(
    BuildContext context,
    EditUserViewModel model, {
    required List<FilterOption> listMenu,
    required int selectedMenu,
    required void Function({
      required int selectedMenu,
    }) setSelectedMenu,
  }) {
    final List<FilterOption> menuLocal = convertToNewList(listMenu);
    int menu = selectedMenu;

    showGeneralBottomSheet(
      context: context,
      title: 'Peran',
      isFlexible: true,
      showCloseButton: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildMenuChoices(
                menuLocal,
                (int selectedIndex) {
                  menu = selectedIndex;
                  for (int i = 0; i < menuLocal.length; i++) {
                    if (i == selectedIndex) {
                      menuLocal[i].isSelected = true;
                      continue;
                    }

                    menuLocal[i].isSelected = false;
                  }
                  setState(() {});
                },
              ),
              Spacings.vert(32),
              ButtonWidget(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.large,
                text: "Terapkan",
                onTap: () {
                  setSelectedMenu(
                    selectedMenu: menu,
                  );
                  Navigator.maybePop(context);
                },
              )
            ],
          );
        },
      ),
    );
  }
}
