import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/add_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  void _showBottomDialog(
    BuildContext context,
    AddCustomerViewModel model, {
    required String title,
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
      title: title,
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

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddCustomerViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      builder: (context, model, _) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah Pelanggan",
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
            onTap: () {
              bool result = model.saveData();
              if (result) Navigator.maybePop(context);
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
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
                        title: "Sumber Data",
                        listMenu: model.sumberDataOptions,
                        selectedMenu: model.selectedSumberDataOption,
                        setSelectedMenu: model.setSelectedSumberData,
                      );
                    },
                    child: TextInput.disabled(
                      label: "Sumber Data",
                      text: model.sumberDataOptions
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
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
                        title: "Tipe Pelanggan",
                        listMenu: model.tipePelangganOptions,
                        selectedMenu: model.selectedTipePelangganOption,
                        setSelectedMenu: model.setSelectedTipePelanggan,
                      );
                    },
                    child: TextInput.disabled(
                      label: "Tipe Pelangggan",
                      text: model.tipePelangganOptions
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
                  TextInput.editable(
                    label: "Nomor Pelanggan",
                    hintText: "Nomor Pelanggan",
                    controller: model.customerNumberController,
                    onChangedListener: model.onChangedCustomerNumber,
                    errorText: !model.isCustomerNumberValid
                        ? "Kolom ini wajib diisi."
                        : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Nama Pelanggan",
                    hintText: "Nama Pelanggan",
                    controller: model.customerNameController,
                    onChangedListener: model.onChangedCustomerName,
                    errorText: !model.isCustomerNameValid
                        ? "Kolom ini wajib diisi."
                        : null,
                  ),
                  Spacings.vert(24),
                  if (model.selectedTipePelangganOption == 1) ...[
                    TextInput.editable(
                      label: "Nama Perusahaan",
                      hintText: "Nama Perusahaan",
                      controller: model.companyNameController,
                      onChangedListener: model.onChangedCompanyName,
                      errorText: !model.isCompanyNameValid
                          ? "Kolom ini wajib diisi."
                          : null,
                    ),
                    Spacings.vert(24),
                  ],
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
                        title: "Kebutuhan Pelanggan",
                        listMenu: model.kebutuhanPelangganOptions,
                        selectedMenu: model.selectedKebutuhanPelangganOption,
                        setSelectedMenu: model.setSelectedKebutuhanPelanggan,
                      );
                    },
                    child: TextInput.disabled(
                      label: "Kebutuhan Pelangggan",
                      text: model.kebutuhanPelangganOptions
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
                  TextInput.editable(
                    label: "Kota",
                    hintText: "Kota",
                    controller: model.cityController,
                    onChangedListener: model.onChangedCity,
                    errorText:
                        !model.isCityValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "No Telepon",
                    hintText: "081xxxxxxxxxxx",
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
                    hintText: "pelanggan@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: model.emailController,
                    onChangedListener: model.onChangedEmail,
                    errorText:
                        !model.isEmailValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.multiline(
                    label: "Catatan",
                    hintText: "Tulis catatan disini...",
                    controller: model.noteController,
                    onChangedListener: (text) {},
                    minLines: 5,
                    maxLines: 5,
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
