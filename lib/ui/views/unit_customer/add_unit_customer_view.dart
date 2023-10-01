import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/add_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

enum CustomerType {
  ProjectCustomer,
  NonProjectCustomer,
}

class AddUnitCustomerViewParam {
  AddUnitCustomerViewParam({
    this.customerType,
    this.customerData,
    this.projectData,
    this.sourcePageForList,
  });

  CustomerType? customerType;
  CustomerData? customerData;
  ProjectData? projectData;
  ListUnitCustomerSourcePage? sourcePageForList;
}

class AddUnitCustomerView extends StatefulWidget {
  const AddUnitCustomerView({
    required this.param,
    super.key,
  });

  final AddUnitCustomerViewParam param;

  @override
  State<AddUnitCustomerView> createState() => _AddUnitCustomerViewState();
}

class _AddUnitCustomerViewState extends State<AddUnitCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddUnitCustomerViewModel(
        customerType: widget.param.customerType,
        customerData: widget.param.customerData,
        projectData: widget.param.projectData,
        sourcePageForList: widget.param.sourcePageForList,
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (AddUnitCustomerViewModel model) async {
        await model.initModel();

        _handleErrorDialog(
          context,
          model,
        );
      },
      builder: (context, model, _) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah Unit",
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
              buildLoadingDialog(context);
              final bool result = await model.requestCreateUnit();
              Navigator.pop(context);

              showDialogWidget(
                context,
                title: "Ubah Data Unit",
                description: result
                    ? "Perubahan data unit berhasil disimpan"
                    : model.errorMsg ?? "Perubahan data unit gagal.",
                isSuccessDialog: result,
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
                    controller: model.nameController,
                    label: "Nama Unit",
                    hintText: "Nama Unit",
                    onChangedListener: model.onChangedName,
                    errorText:
                        !model.isNameValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.locationController,
                    label: "Lokasi Unit",
                    hintText: "Lokasi Unit",
                    onChangedListener: model.onChangedLocation,
                    errorText: !model.isLocationValid
                        ? "Kolom ini wajib diisi."
                        : null,
                  ),
                  if (model.isAllowedToChooseProject) ...[
                    Spacings.vert(24),
                    GestureDetector(
                      onTap: () {
                        _showPilihProyekBottomDialog(
                          context,
                          model,
                          setSelectedMenu: model.setSelectedProyek,
                        );
                      },
                      child: TextInput.disabled(
                        label: "Pilih Proyek",
                        text: model.selectedProyek?.projectName,
                        hintText: "Pilih Proyek untuk Unit ini",
                        suffixIcon: const Icon(
                          PhosphorIcons.caretDownBold,
                          color: MyColors.lightBlack02,
                        ),
                      ),
                    ),
                  ],
                  if (model.sourcePageForList ==
                      ListUnitCustomerSourcePage.DetailProject) ...[
                    Spacings.vert(24),
                    TextInput.disabled(
                      label: "Proyek",
                      text: widget.param.projectData?.projectName,
                      hintText: "Tidak ada Proyek untuk Unit ini",
                    ),
                  ],
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChangedListener: model.onChangedSpeed,
                    errorText:
                        !model.isSpeedValid ? "Kolom ini wajib diisi." : null,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Jumlah Lantai / Lebar Step",
                    controller: model.totalLantaiController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    hintText: "Jumlah Lantai / Lebar Step",
                    onChangedListener: model.onChangedTotalLantaiController,
                    errorText: !model.isTotalLantaiValid
                        ? "Kolom ini wajib diisi."
                        : null,
                  ),
                  Spacings.vert(24),
                  DatePickerWidget(
                    label: "Tanggal Pemeliharaan Pertama",
                    isRangeCalendar: false,
                    selectedDates: model.selectedNextMaintenanceDates,
                    onSelectedDates: (DateTime start, DateTime? end) {
                      print('$start $end');
                      model.setSelectedNextMaintenanceDates([start]);
                    },
                  ),
                  Spacings.vert(24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPilihProyekBottomDialog(
    BuildContext context,
    AddUnitCustomerViewModel model, {
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
                          desc2Size: 14,
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
    AddUnitCustomerViewModel model, {
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
    AddUnitCustomerViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Proyek",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Proyek. \n Coba beberappa saat lagi.",
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
