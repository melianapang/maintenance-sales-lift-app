import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/form_change_maintenance_date_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class FormChangeMaintenanceDateViewParam {
  FormChangeMaintenanceDateViewParam({
    this.maintenanceData,
  });

  final MaintenanceData? maintenanceData;
}

class FormChangeMaintenanceDateView extends StatefulWidget {
  const FormChangeMaintenanceDateView({
    required this.param,
    super.key,
  });

  final FormChangeMaintenanceDateViewParam param;

  @override
  State<FormChangeMaintenanceDateView> createState() =>
      _FormChangeMaintenanceDateState();
}

class _FormChangeMaintenanceDateState
    extends State<FormChangeMaintenanceDateView> {
  final ScrollController buktiFotoController = ScrollController();
  final ScrollController buktiVideoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormChangeMaintenanceDateViewModel>(
      model: FormChangeMaintenanceDateViewModel(
        maintenanceData: widget.param.maintenanceData,
      ),
      onModelReady: (FormChangeMaintenanceDateViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Ganti Tanggal Pemeliharaan",
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
              top: 24,
            ),
            onTap: () {
              showDialogWidget(
                context,
                title: "Ubah Tanggal Pemeliharaan",
                description:
                    "Apakahh anda yakin ingin mengubah tanggal pemeliharaan ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  showDialogWidget(
                    context,
                    title: "Ubah Tanggal Pemeliharaan",
                    description: "Perubahan data telah disetujui.",
                    isSuccessDialog: true,
                    positiveLabel: "OK",
                    positiveCallback: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop(true);
                    },
                  );
                },
                negativeCallback: () {
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
                Text(
                  model.maintenanceData?.unitName ?? "",
                  style: buildTextStyle(
                    fontSize: 32,
                    fontWeight: 800,
                    fontColor: MyColors.yellow01,
                  ),
                ),
                Text(
                  "PT ABC JAYA",
                  style: buildTextStyle(
                    fontSize: 20,
                    fontWeight: 400,
                    fontColor: MyColors.lightBlack02,
                  ),
                ),
                Spacings.vert(24),
                DatePickerWidget(
                  label: "Ubah Tanggal Pemeliharaan menjadi:",
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
        );
      },
    );
  }
}
