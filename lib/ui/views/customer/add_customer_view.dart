import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/add_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
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
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddCustomerViewModel(
        authenticationService: Provider.of<AuthenticationService>(context),
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (AddCustomerViewModel model) async {
        await model.initModel();
      },
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
            onTap: () async {
              if (!model.isValid()) {
                showDialogWidget(
                  context,
                  title: "Tambah Pelanggan",
                  description:
                      "Isi semua data dengan benar. \n Untuk email dan nomor telepon bisa isi salah satu atau keduanya.",
                  isSuccessDialog: false,
                  positiveLabel: "OK",
                  positiveCallback: () {
                    model.resetErrorMsg();
                    Navigator.pop(context);
                  },
                );
                return;
              }

              showDialogWidget(
                context,
                title: "Tambah Pelanggan",
                description:
                    "Apakah anda yakin ingin menambah data pelanggan ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  if (model.isLoading) return;

                  buildLoadingDialog(context);
                  CustomerData? result = await model.requestCreateCustomer();
                  Navigator.pop(context);

                  showDialogWidget(context,
                      title: "Tambah Pelanggan",
                      description: result != null
                          ? "Berhasil menambah data pelanggan"
                          : model.errorMsg ?? "Gagal menambah data pelanggan",
                      isSuccessDialog: result != null,
                      positiveLabel: "OK", positiveCallback: () {
                    if (result != null) {
                      Navigator.of(context)
                        ..pop()
                        ..pop(result);

                      return;
                    }

                    model.resetErrorMsg();
                    Navigator.pop(context);
                  });
                },
                negativeCallback: () => Navigator.pop(context),
              );
            },
            text: 'Simpan',
          ),
          body: !model.busy
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      24.0,
                    ),
                    child: Column(
                      children: [
                        if (model.isSumberDataFieldVisible) ...[
                          TextInput.editable(
                            label: "Sumber Data",
                            hintText: "Sumber Data",
                            maxLength: 99,
                            controller: model.sumberDataController,
                            onChangedListener: model.onChangedSumberData,
                            errorText: !model.isSumberDataValid
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
                              title: "Tipe Pelanggan",
                              listMenu: model.customerTypeFilterOptions,
                              selectedMenu: model.selectedCustomerTypeFilter,
                              setSelectedMenu: model.setSelectedTipePelanggan,
                            );
                          },
                          child: TextInput.disabled(
                            label: "Tipe Pelangggan",
                            hintText: "Tipe Pelanggan",
                            text: model.customerType,
                            suffixIcon: const Icon(
                              PhosphorIcons.caretDownBold,
                              color: MyColors.lightBlack02,
                            ),
                          ),
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
                        if (model.selectedCustomerTypeFilterStr ==
                            "Perusahaan") ...[
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
                              listMenu: model.customerNeedFilterOptions,
                              selectedMenu: model.selectedCustomerNeedFilter,
                              setSelectedMenu:
                                  model.setSelectedKebutuhanPelanggan,
                            );
                          },
                          child: TextInput.disabled(
                            label: "Kebutuhan Pelangggan",
                            hintText: "Kebutuhan Pelanggan",
                            text: model.customerNeed,
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
                          errorText: !model.isCityValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          label: "No Telepon",
                          hintText: "081xxxxxxxxxxx",
                          keyboardType: TextInputType.number,
                          controller: model.phoneNumberController,
                          onChangedListener: model.onChangedPhoneNumber,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          label: "Email",
                          hintText: "email@email.com",
                          keyboardType: TextInputType.emailAddress,
                          controller: model.emailController,
                          onChangedListener: model.onChangedEmail,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          label: "Catatan",
                          hintText: "Tulis catatan disini...",
                          controller: model.noteController,
                          onChangedListener: (text) {},
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    buildLoadingPage(),
                  ],
                ),
        );
      },
    );
  }

  void _showBottomDialog(
    BuildContext context,
    AddCustomerViewModel model, {
    required String title,
    required List<FilterOptionDynamic> listMenu,
    required int selectedMenu,
    required void Function({
      required int selectedMenu,
    }) setSelectedMenu,
  }) {
    final List<FilterOptionDynamic> menuLocal =
        convertToNewListForFilterDynamic(listMenu);
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
            mainAxisSize: MainAxisSize.min,
            children: [
              buildMenuDynamicChoices(
                menuLocal,
                (int selectedIdFilter) {
                  menu = selectedIdFilter;
                  for (FilterOptionDynamic menu in menuLocal) {
                    if (int.parse(menu.idFilter) == selectedIdFilter) {
                      menu.isSelected = true;
                      continue;
                    }
                    menu.isSelected = false;
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
