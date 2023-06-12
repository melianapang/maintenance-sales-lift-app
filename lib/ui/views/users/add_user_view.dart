import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/add_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/set_password_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
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
      model: AddUserViewModel(
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
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
              bool result = model.isValid();
              if (result)
                Navigator.pushNamed(
                  context,
                  Routes.setPasswordUser,
                  arguments: SetPasswordUserViewParam(
                    profileData: ProfileData(
                      username: model.usernameController.text,
                      name: model.nameController.text,
                      city: model.cityController.text,
                      address: model.addressController.text,
                      role: model.getSelectedRole(),
                      phoneNumber: model.phoneNumberController.text,
                      email: model.emailController.text,
                    ),
                  ),
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
                TextInput.editable(
                  label: "Username",
                  hintText: "Username",
                  controller: model.usernameController,
                  onChangedListener: model.onChangedUsername,
                  errorText:
                      !model.isUsernameValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
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
                        .where(
                          (element) => element.isSelected,
                        )
                        .first
                        .title,
                    suffixIcon: const Icon(
                      PhosphorIcons.caretDownBold,
                      color: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(24),
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
    AddUserViewModel model, {
    required List<FilterOption> listMenu,
    required int selectedMenu,
    required void Function({
      required int selectedMenu,
    })
        setSelectedMenu,
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
