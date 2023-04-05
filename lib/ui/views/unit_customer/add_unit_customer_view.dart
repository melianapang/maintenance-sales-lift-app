import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/add_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddUnitCustomerView extends StatefulWidget {
  const AddUnitCustomerView({super.key});

  @override
  State<AddUnitCustomerView> createState() => _AddUnitCustomerViewState();
}

class _AddUnitCustomerViewState extends State<AddUnitCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddUnitCustomerViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (AddUnitCustomerViewModel model) async {
        await model.initModel();
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
              //belom bener
              // final bool result = await model.requestUpdateCustomer();
              final bool result = true;
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
                    label: "Nama Unit",
                    hintText: "Nama Unit",
                    onChangedListener: (text) {},
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    label: "Lokasi Unit",
                    hintText: "Lokasi Unit",
                    onChangedListener: (text) {},
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
                      text: model.selectedProyek?.customerName,
                      hintText: "Pilih Proyek untuk Unit ini",
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.lightBlack02,
                      ),
                    ),
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
      child: Expanded(
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
      ),
    );
  }
}