import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/export_data_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExportDataMaintenanceView extends StatefulWidget {
  const ExportDataMaintenanceView({super.key});

  @override
  State<ExportDataMaintenanceView> createState() =>
      _ExportDataMaintenanceViewState();
}

class _ExportDataMaintenanceViewState extends State<ExportDataMaintenanceView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ExportDataMaintenanceViewModel(),
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
                    selectedDates: [],
                    onSelectedDates: (DateTime start, DateTime? end) {
                      print('$start $end');
                    },
                  ),
                  Spacings.vert(24),
                  GestureDetector(
                    onTap: () {},
                    child: TextInput.disabled(
                      label: "Status Pemeliharaan",
                      text: 'Semua',
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
                      text: 'Semua',
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
                      label: "Unit Lift",
                      text: 'Semua',
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
