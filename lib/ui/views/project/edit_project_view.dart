import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/edit_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class EditProjectViewParam {
  EditProjectViewParam({
    this.projectData,
  });
  final ProjectData? projectData;
}

class EditProjectView extends StatefulWidget {
  const EditProjectView({
    required this.param,
    super.key,
  });

  final EditProjectViewParam param;

  @override
  State<EditProjectView> createState() => _EditProjectViewState();
}

class _EditProjectViewState extends State<EditProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: EditProjectViewModel(
        projectData: widget.param.projectData,
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (EditProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Edit Data Proyek",
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
              bool isValid = model.isValid();
              if (!isValid) return;

              showDialogWidget(
                context,
                title: "Mengubahh Data Proyek",
                description:
                    "Apakah anda yakin ingin mengubah data proyek ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                negativeCallback: () {
                  Navigator.maybePop(context);
                },
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  buildLoadingDialog(context);
                  bool result = await model.requestUpdateProject();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Ubah Data Proyek",
                    description: result
                        ? "Perubahan data proyek berhasil disimpan."
                        : model.errorMsg ??
                            "Perubahan data proyek gagal disimpan.",
                    isSuccessDialog: result,
                    positiveLabel: "Ok",
                    positiveCallback: () {
                      if (result) {
                        Navigator.of(context)
                          ..pop()
                          ..pop(result);
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
                      setSelectedMenu: model.setSelectedCustomer,
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
                        title: model.listPic[index].picName,
                        description: model.listPic[index].phoneNumber,
                        desc2Size: 12,
                        titleSize: 14,
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
    EditProjectViewModel model, {
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
    required EditProjectViewModel viewModel,
  }) async {
    final result = await Navigator.pushNamed(context, Routes.addPicProject);
    setState(() {
      viewModel.addPicProject(result as PICProject);
    });
  }

  void _showPilihCustomerBottomDialog(
    BuildContext context,
    EditProjectViewModel model, {
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
      child: !model.isShowNoDataFoundPage && !model.busy
          ? Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () => model.requestGetAllCustomer(),
                scrollDirection: Axis.vertical,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.listCustomer?.length ?? 0,
                  separatorBuilder: (_, __) => const Divider(
                    color: MyColors.transparent,
                    height: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCardWidget(
                      cardType: CardType.list,
                      title: model.listCustomer?[index].customerName ?? "",
                      description: model.listCustomer?[index].companyName,
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
            )
          : buildNoDataFoundPage(),
    );
  }
}
