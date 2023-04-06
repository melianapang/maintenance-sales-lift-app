import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_customer_model.dart';
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
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class EditUnitCustomerViewParam {
  EditUnitCustomerViewParam({
    this.unitData,
  });

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
      ),
      onModelReady: (EditUnitCustomerViewModel model) async {
        await model.initModel();
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
                        //belom bener
                        final bool result = await model.requestUpdateCustomer();
                        if (result == false) {
                          showDialogWidget(
                            context,
                            title: "Ubah Data Unit",
                            description: "Perubahan data unit gagal.",
                            isSuccessDialog: false,
                          );
                          return;
                        }

                        await Navigator.maybePop(context);
                        showDialogWidget(
                          context,
                          title: "Ubah Data Unit",
                          description: "Perubahan data unit berhasil disimpan",
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
                        Spacings.vert(24),
                        TextInput.editable(
                          controller: model.namaUnitController,
                          label: "Nama Unit",
                          hintText: "Nama Unit",
                        ),
                        Spacings.vert(24),
                        TextInput.editable(
                          controller: model.lokasiUnitController,
                          label: "Lokasi Unit",
                          hintText: "Lokasi Unit",
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
                            label: "Proyek Unit",
                            text: model.selectedProyek?.customerName ??
                                model.unitData?.unitName,
                            hintText: "Pilih Proyek untuk Unit ini",
                            suffixIcon: const Icon(
                              PhosphorIcons.caretDownBold,
                              color: MyColors.lightBlack02,
                            ),
                          ),
                        ),
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
