import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/add_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
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
      model: AddUnitCustomerViewModel(),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
