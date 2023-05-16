import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/add_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddUnitCustomerViewParam {
  AddUnitCustomerViewParam({
    this.customerData,
  });

  CustomerData? customerData;
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
        customerData: widget.param.customerData,
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
    })
        setSelectedMenu,
  }) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Proyek',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: !model.isShowNoDataFoundPage && !model.busy
          ? Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () => model.requestGetAllProjectByCustomerId(),
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
              ),
            )
          : buildNoDataFoundPage(),
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
