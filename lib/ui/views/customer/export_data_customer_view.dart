import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/export_data_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class ExportDataCustomerView extends StatefulWidget {
  const ExportDataCustomerView({super.key});

  @override
  State<ExportDataCustomerView> createState() => _ExportDataCustomerViewState();
}

class _ExportDataCustomerViewState extends State<ExportDataCustomerView> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ExportDataCustomerViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Export Data",
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
            onTap: () {},
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  DatePickerWidget(
                    label: "Rentang Tanggal",
                    isRangeCalendar: true,
                    selectedDates: model.selectedDates,
                    onSelectedDates: (DateTime start, DateTime? end) {
                      print('$start $end');
                      model.setSelectedDates([
                        start,
                        if (end != null) end,
                      ]);
                    },
                  ),
                  Spacings.vert(24),
                  GestureDetector(
                    onTap: () {},
                    child: TextInput.disabled(
                      label: "Tipe Pelanggan",
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.darkBlue01,
                        size: 16,
                      ),
                    ),
                  ),
                  Spacings.vert(24),
                  GestureDetector(
                    onTap: () {},
                    child: TextInput.disabled(
                      label: "Nama Pelanggan",
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.darkBlue01,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
