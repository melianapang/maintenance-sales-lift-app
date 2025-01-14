import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/edit_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import '../../shared/app_bars.dart';

class EditUnitCustomerViewParam {
  EditUnitCustomerViewParam({
    this.customerData,
    this.unitData,
  });

  final CustomerData? customerData;
  final UnitData? unitData;
}

class EditUnitCustomerView extends StatefulWidget {
  const EditUnitCustomerView({
    required this.param,
    super.key,
  });

  final EditUnitCustomerViewParam param;

  @override
  State<EditUnitCustomerView> createState() => _EditUnitCustomerViewState();
}

class _EditUnitCustomerViewState extends State<EditUnitCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: EditUnitCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        unitData: widget.param.unitData,
        customerData: widget.param.customerData,
      ),
      onModelReady: (EditUnitCustomerViewModel model) async {
        await model.initModel();

        _handleErrorDialog(
          context,
          model,
        );
      },
      builder: (context, model, _) {
        return !model.busy
            ? Scaffold(
                backgroundColor: MyColors.darkBlack01,
                appBar: buildDefaultAppBar(
                  context,
                  title: "Edit Data Unit",
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
                      title: "Mengubahh Data Unit",
                      description:
                          "Apakah anda yakin ingin mengubah data unit ini?",
                      positiveLabel: "Iya",
                      negativeLabel: "Tidak",
                      negativeCallback: () {
                        Navigator.maybePop(context);
                      },
                      positiveCallback: () async {
                        Navigator.pop(context);

                        buildLoadingDialog(context);
                        final bool result = await model.requestUpdateUnit();
                        Navigator.pop(context);

                        showDialogWidget(
                          context,
                          title: "Ubah Data Unit",
                          isSuccessDialog: result,
                          description: result
                              ? "Perubahan data unit berhasil disimpan"
                              : model.errorMsg ??
                                  "Perubahan data unit gagal disimpan.",
                          positiveLabel: "Okay",
                          positiveCallback: () {
                            if (result) {
                              Navigator.of(context)
                                ..pop()
                                ..pop(result);
                              return;
                            }

                            model.resetErrorMsg();
                            Navigator.pop(context);
                          },
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
                          controller: model.namaUnitController,
                          label: "Nama Unit",
                          hintText: "Nama Unit",
                          onChangedListener: model.onChangedNama,
                          errorText: !model.isNamaValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          controller: model.lokasiUnitController,
                          label: "Lokasi Unit",
                          hintText: "Lokasi Unit",
                          onChangedListener: model.onChangedLocation,
                          errorText: !model.isLocationValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                        if (model.selectedProyek?.projectId.isNotEmpty ==
                                true ||
                            model.unitData?.projectId?.isNotEmpty == true)
                          GestureDetector(
                            onTap: () {
                              _showPilihProyekBottomDialog(
                                context,
                                model,
                                setSelectedMenu: model.setSelectedProyek,
                              );
                            },
                            child: TextInput.disabled(
                              label: "Proyek Unit",
                              text: model.selectedProyek?.projectName,
                              hintText: "Pilih Proyek untuk Unit ini",
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
                              title: "Tipe Unit",
                              listMenu: model.tipeUnitOptions,
                              selectedMenu: model.selectedTipeUnitOption,
                              setSelectedMenu: model.setSelectedTipeUnit,
                            );
                          },
                          child: TextInput.disabled(
                            label: "Tipe Unit",
                            hintText: "Tipe Unit",
                            text: model.selectedTipeUnitString,
                            suffixIcon: const Icon(
                              PhosphorIcons.caretDownBold,
                              color: MyColors.lightBlack02,
                            ),
                          ),
                        ),
                        Spacings.vert(24),
                        if (model.selectedTipeUnitOption != 3) ...[
                          GestureDetector(
                            onTap: () {
                              _showBottomDialog(
                                context,
                                model,
                                title: "Jenis Unit",
                                listMenu: model.jenisUnitOptions,
                                selectedMenu: model.selectedJenisUnitOption,
                                setSelectedMenu: model.setSelectedJenisUnit,
                              );
                            },
                            child: TextInput.disabled(
                              label: "Jenis Unit",
                              hintText: "Jenis Unit",
                              text: model.selectedJenisUnitString,
                              suffixIcon: const Icon(
                                PhosphorIcons.caretDownBold,
                                color: MyColors.lightBlack02,
                              ),
                            ),
                          ),
                          Spacings.vert(24),
                        ],
                        TextInput.editable(
                          label: "Kapasitas / Rise",
                          controller: model.kapasitasController,
                          hintText: "Kapasitas / Rise",
                          keyboardType: TextInputType.number,
                          onChangedListener: model.onChangedKapasitas,
                          errorText: !model.isKapasitasValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          label: "Speed / Inclinasi",
                          controller: model.speedController,
                          hintText: "Speed / Inclinasi",
                          keyboardType: TextInputType.number,
                          onChangedListener: model.onChangedSpeed,
                          errorText: !model.isSpeedValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          label: "Jumlah Lantai / Lebar Step",
                          controller: model.totalLantaiController,
                          keyboardType: TextInputType.number,
                          hintText: "Jumlah Lantai / Lebar Step",
                          onChangedListener:
                              model.onChangedTotalLantaiController,
                          errorText: !model.isTotalLantaiValid
                              ? "Kolom ini wajib diisi."
                              : null,
                        ),
                        Spacings.vert(24),
                      ],
                    ),
                  ),
                ),
              )
            : buildLoadingPage();
      },
    );
  }

  void _showPilihProyekBottomDialog(
    BuildContext context,
    EditUnitCustomerViewModel model, {
    required void Function({
      required int selectedIndex,
    }) setSelectedMenu,
  }) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Proyek',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: !model.isShowNoDataFoundPage && !model.busy
          ? Expanded(
              child: StatefulBuilder(
                builder: (context, ss) {
                  return LazyLoadScrollView(
                    onEndOfPage: () {
                      ss(() {
                        model.requestGetAllProjectByCustomerId();
                      });
                    },
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.listProject?.length ?? 0,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: model.listProject?[index].projectName ?? "",
                          description:
                              "Kebutuhan Proyek: ${mappingProjectNeedTypeToString(
                            int.parse(
                              model.listProject?[index].projectNeed ?? "0",
                            ),
                          )}",
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
                  );
                },
              ),
            )
          : buildNoDataFoundPage(),
    );
  }

  void _showBottomDialog(
    BuildContext context,
    EditUnitCustomerViewModel model, {
    required String title,
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
      title: title,
      isFlexible: true,
      showCloseButton: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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

  void _handleErrorDialog(
    BuildContext context,
    EditUnitCustomerViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Unit",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Unit. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.requestGetAllProjectByCustomerId();
        Navigator.pop(context);

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
