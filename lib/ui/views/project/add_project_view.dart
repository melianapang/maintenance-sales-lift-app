import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/add_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/pin_project_location_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/choose_customer_bottom_sheet.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
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
                      title: "Keperluan Proyek",
                      listMenu: model.keperluanProyekFilterOptions,
                      selectedMenu: model.selectedKeperluanProyekOption,
                      setSelectedMenu: model.setSelectedKeperluanProyek,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Keperluan Proyek",
                    hintText: "Keperluan Proyek",
                    text: model.customerNeed,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextInput.disabled(
                        label: "Koordinat Lokasi",
                        hintText: "Contoh: (0.0 , 0.0)",
                        text: model.projectLocation != null
                            ? StringUtils.removeZeroWidthSpaces(
                                "${model.projectLocation?.longitude ?? 0.0}, ${model.projectLocation?.latitude ?? 0.0}")
                            : null,
                      ),
                    ),
                    Spacings.horz(6),
                    GestureDetector(
                      onTap: () => _awaitPinProjectLocationViewResult(
                        context,
                        viewModel: model,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyColors.lightBlack01,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 58,
                        height: 58,
                        child: const Icon(
                          PhosphorIcons.mapPinFill,
                          color: MyColors.yellow01,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacings.vert(4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "*Opsional",
                    style: buildTextStyle(
                      fontSize: 12,
                      fontColor: MyColors.lightBlack001,
                      fontWeight: 400,
                    ),
                  ),
                ),
                if (model.detectedProjectAddress != null &&
                    model.detectedProjectAddress?.isNotEmpty == true)
                  Text(
                    "Perkiraan alamat: ${model.detectedProjectAddress ?? ""}",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontColor: MyColors.lightBlack01,
                      fontWeight: 400,
                    ),
                  ),
                Spacings.vert(24),
                DatePickerWidget(
                  label: "Tanggal Konfirmasi Pertama",
                  isRangeCalendar: false,
                  selectedDates: model.selectedFirstFollowUpDates,
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
                    model.setSelectedFirstFollowUpDates([start]);
                  },
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
                            "${model.listPic[index].picName} - ${model.listPic[index].role}",
                        description: model.listPic[index].email,
                        description2: model.listPic[index].phoneNumber,
                        desc2Size: 12,
                        descSize: 12,
                        titleSize: 16,
                        icon: model.isPicSameWithCustomer == true
                            ? null
                            : PhosphorIcons.trashBold,
                        onTap: () {
                          if (model.isPicSameWithCustomer == true) return;
                          model.deletePicProject(index);
                        },
                      );
                    },
                  ),
                Spacings.vert(12),
                if (model.listPic.length < 5 &&
                    model.isPicSameWithCustomer != true)
                  GestureDetector(
                    onTap: () {
                      if (model.isPicSameWithCustomer == true) return;
                      _showAddPicFromDialog(context, model: model);
                    },
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

  Future _showAddPicFromDialog(
    BuildContext context, {
    required AddProjectViewModel model,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PIC Proyek',
                    style: buildTextStyle(
                      fontSize: 18,
                      fontWeight: 500,
                      fontColor: MyColors.darkBlack01,
                    ),
                  ),
                  Spacings.vert(18),
                  Column(
                    children: [
                      ButtonWidget(
                        buttonType: ButtonType.primary,
                        buttonSize: ButtonSize.medium,
                        text: 'PIC sama dengan Pelanggan',
                        onTap: () {
                          Navigator.pop(context);
                          model.setIsPicSameWithCustomer(true);
                        },
                      ),
                      Spacings.vert(8),
                      ButtonWidget(
                        buttonType: ButtonType.secondary,
                        buttonSize: ButtonSize.medium,
                        text: 'Tambah Data PIC Baru',
                        onTap: () {
                          Navigator.pop(context);
                          model.setIsPicSameWithCustomer(true);

                          _awaitAddPicProjectViewResult(
                            context,
                            viewModel: model,
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _awaitAddPicProjectViewResult(
    BuildContext context, {
    required AddProjectViewModel viewModel,
  }) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.addPicProject,
      arguments: AddPicProjectViewParam(
        listRole: viewModel.listPICRole,
      ),
    );
    setState(() {
      if (viewModel.isPicSameWithCustomer == true) return;
      viewModel.addPicProject(result as PICProject);
    });
  }

  void _awaitPinProjectLocationViewResult(
    BuildContext context, {
    required AddProjectViewModel viewModel,
  }) async {
    Position? currPosition = await viewModel.getCurrentPosition();
    // ignore: use_build_context_synchronously
    final result = await Navigator.pushNamed(
      context,
      Routes.pinProjectLocation,
      arguments: PinProjectLocationViewParam(
        longLat: currPosition,
      ),
    ) as LatLng?;
    setState(() {
      if (result == null) return;

      print("POINT: ${result.longitude}, ${result.latitude}");
      viewModel.pinProjectLocation(result);
    });
  }

  void _showPilihCustomerBottomDialog(
      BuildContext context, AddProjectViewModel model) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Pelanggan',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: ChooseCustomerBottomSheet(
        selectedCustomerCallback: ((CustomerData? customerData) {
          if (customerData == null) return;
          model.setSelectedCustomer(customerData);
        }),
      ),
    );
  }
}
