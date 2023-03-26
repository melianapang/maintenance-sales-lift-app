import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/edit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class EditCustomerView extends StatefulWidget {
  const EditCustomerView({super.key});

  @override
  State<EditCustomerView> createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends State<EditCustomerView> {
  void _showBottomDialog(
    BuildContext context,
    EditCustomerViewModel model, {
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
      title: 'Kebutuhan Pelanggan',
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
      model: EditCustomerViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (EditCustomerViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Edit Data Pelanggan",
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
            onTap: () async {
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
                  final bool result = await model.requestUpdateCustomer();
                  if (result == false) {
                    showDialogWidget(
                      context,
                      title: "Ubah Data User",
                      description: "Perubahan data user gagal.",
                      isSuccessDialog: false,
                    );
                    return;
                  }

                  await Navigator.maybePop(context);
                  showDialogWidget(
                    context,
                    title: "Ubah Data User",
                    description: "Perubahan data user berhasil disimpan",
                    isSuccessDialog: true,
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
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
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
                    onChangedListener: (text) {},
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Nama Pelanggan",
                    hintText: "Nama Pelanggan",
                    onChangedListener: (text) {},
                  ),
                  Spacings.vert(24),
                  if (model.selectedTipePelangganOption == 1) ...[
                    TextInput.editable(
                      onChangedListener: (text) {},
                      label: "Nama Perusahaan",
                      hintText: "Nama Perusahaan",
                    ),
                    Spacings.vert(24),
                  ],
                  GestureDetector(
                    onTap: () {
                      _showBottomDialog(
                        context,
                        model,
                        listMenu: model.kebutuhanPelangganOptions,
                        selectedMenu: model.selectedKebutuhanPelangganOption,
                        setSelectedMenu: model.setSelectedKebutuhanPelanggan,
                      );

                      setState(() {});
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
                    label: "Nomor Telepon",
                    hintText: "081xxxxxxxxxx",
                    keyboardType: TextInputType.number,
                    onChangedListener: (text) {},
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Kota",
                    hintText: "Kota",
                    onChangedListener: (text) {},
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Email",
                    hintText: "pelanggan@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    onChangedListener: (text) {},
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
