import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/add_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import 'add_pic_project_view.dart';

class AddProjectView extends StatefulWidget {
  const AddProjectView({super.key});

  @override
  State<AddProjectView> createState() => _AddProjectViewState();
}

class _AddProjectViewState extends State<AddProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddProjectViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (AddProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah Proyek",
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
            onTap: () async {
              bool result = model.isValid();
              if (!result) {
                showDialogWidget(
                  context,
                  title: "Tambah Data Proyek",
                  description: "Wajib mengisi semua informasi yang diperlukan.",
                  isSuccessDialog: false,
                  positiveLabel: "Okay",
                  positiveCallback: () => Navigator.pop(context),
                );
                return;
              }

              buildLoadingDialog(context);
              bool isSucceed = await model.requestCreateProject();
              if (!isSucceed) {
                Navigator.pop(context);
                showDialogWidget(
                  context,
                  title: "Tambah Data Proyek",
                  description:
                      model.errorMsg ?? "Gagal menambahkan data proyek.",
                  isSuccessDialog: false,
                  positiveLabel: "Okay",
                  positiveCallback: () {
                    model.resetErrorMsg();
                    Navigator.pop(context);
                  },
                );
                return;
              }

              bool isSucceedCreatePIC = await model.requestCreatePICs();
              Navigator.pop(context);

              showDialogWidget(
                context,
                title: "Tambah Data Proyek",
                description: isSucceedCreatePIC
                    ? "Berhasil menambahkan data proyek"
                    : model.errorMsg ?? "Gagal menambahkan data proyek.",
                isSuccessDialog: isSucceedCreatePIC,
                positiveLabel: "Okay",
                positiveCallback: () {
                  if (isSucceedCreatePIC) {
                    Navigator.of(context)
                      ..pop()
                      ..pop(isSucceed);

                    return;
                  }

                  model.resetErrorMsg();
                  Navigator.maybePop(context);
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
                  label: "Nama Proyek",
                  hintText: "Nama Proyek",
                  onChangedListener: model.onChangedName,
                  controller: model.nameController,
                  errorText:
                      !model.isNameValid ? "Kolom ini wajib diisi." : null,
                ),
                Spacings.vert(24),
                GestureDetector(
                  onTap: () {
                    _showPilihCustomerBottomDialog(
                      context,
                      model,
                      setSelectedMenu: model.setSelectedCustomerByIndex,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Nama Pelanggan",
                    text: model.selectedCustomer?.customerName,
                    hintText: "Pilih Pelangan untuk Proyek ini",
                    suffixIcon: const Icon(
                      PhosphorIcons.caretDownBold,
                      color: MyColors.lightBlack02,
                    ),
                    actionWidget: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final dynamic result = await Navigator.pushNamed(
                          context,
                          Routes.addCustomer,
                        );
                        if (result is CustomerData) {
                          await model.initModel();
                          model.setSelectedCustomer(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        child: Text(
                          'Tambah Pelanggan Baru',
                          style: buildTextStyle(
                            fontSize: 12,
                            fontWeight: 600,
                            fontColor: MyColors.yellow01,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacings.vert(24),
                GestureDetector(
                  onTap: () {
                    _showKeperluanProyekBottomDialog(
                      context,
                      model,
                      listMenu: model.keperluanProyekOptions,
                      selectedMenu: model.selectedKeperluanProyekOption,
                      setSelectedMenu: model.setSelectedKeperluanProyek,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Keperluan Proyek",
                    text: model.keperluanProyekOptions
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
                  label: "Alamat",
                  hintText: "Alamat Proyek",
                  controller: model.addressController,
                  onChangedListener: model.onChangedAddress,
                  errorText:
                      !model.isAdressValid ? "Kolom ini wajib diisi." : null,
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
                Text(
                  "PIC Proyek",
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02,
                  ),
                ),
                Spacings.vert(12),
                if (model.listPic.isEmpty)
                  Text(
                    "Belum ada data PIC untuk proyek ini.",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontColor: MyColors.lightBlack02.withOpacity(
                        0.5,
                      ),
                      fontWeight: 300,
                    ),
                  ),
                if (model.listPic.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: model.listPic.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: MyColors.transparent,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CustomCardWidget(
                        cardType: CardType.listWithIcon,
                        title:
                            "${model.listPic[index].picName} - ${model.listPic[index].picName}",
                        description: model.listPic[index].phoneNumber,
                        description2: model.listPic[index].picName,
                        desc2Size: 12,
                        descSize: 12,
                        titleSize: 16,
                        icon: PhosphorIcons.trashBold,
                        onTap: () {
                          model.deletePicProject(index);
                        },
                      );
                    },
                  ),
                Spacings.vert(12),
                if (model.listPic.length < 5)
                  GestureDetector(
                    onTap: () => _awaitAddPicProjectViewResult(
                      context,
                      viewModel: model,
                    ),
                    child: Text(
                      'Tambahkan PIC Proyek',
                      textAlign: TextAlign.start,
                      style: buildTextStyle(
                        fontSize: 14,
                        fontWeight: 400,
                        fontColor: MyColors.blueLihatSelengkapnya,
                        isUnderlined: true,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showKeperluanProyekBottomDialog(
    BuildContext context,
    AddProjectViewModel model, {
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
      title: 'Keperluan Proyek',
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

  void _awaitAddPicProjectViewResult(
    BuildContext context, {
    required AddProjectViewModel viewModel,
  }) async {
    final result = await Navigator.pushNamed(context, Routes.addPicProject);
    setState(() {
      viewModel.addPicProject(result as PICProject);
    });
  }

  void _showPilihCustomerBottomDialog(
    BuildContext context,
    AddProjectViewModel model, {
    required void Function({
      required int selectedIndex,
    })
        setSelectedMenu,
  }) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Pelanggan',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: Expanded(
        child: StatefulBuilder(
          builder: (context, ss) {
            return FutureBuilder<List<CustomerData>>(
              future: model.searchOnChanged(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    buildSearchBar(
                      context,
                      isFilterShown: false,
                      searchController: model.searchController,
                      textSearchOnChanged: (_) {
                        model.isSearch = true;
                        ss(() {});
                      },
                    ),
                    if (!model.isShowNoDataFoundPage && !model.isLoading)
                      Expanded(
                        child: LazyLoadScrollView(
                          onEndOfPage: () {
                            model.isSearch = false;
                            ss(() {});
                          },
                          child: ListView.separated(
                            itemCount: snapshot.data?.length ?? 0,
                            separatorBuilder: (_, __) => const Divider(
                              color: MyColors.transparent,
                              height: 20,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCardWidget(
                                cardType: CardType.list,
                                title: snapshot.data?[index].customerName ?? "",
                                description: snapshot.data?[index].companyName,
                                desc2Size: 16,
                                titleSize: 20,
                                onTap: () {
                                  setSelectedMenu(
                                    selectedIndex: index,
                                  );
                                  Navigator.maybePop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    if (model.isShowNoDataFoundPage && !model.isLoading)
                      buildNoDataFoundPage(),
                    if (model.isLoading) buildLoadingPage(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
