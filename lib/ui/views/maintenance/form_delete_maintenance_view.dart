import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/form_delete_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class FormDeleteMaintenanceViewParam {
  FormDeleteMaintenanceViewParam({
    this.maintenanceData,
  });

  final MaintenanceData? maintenanceData;
}

class FormDeleteMaintenanceView extends StatefulWidget {
  const FormDeleteMaintenanceView({
    required this.param,
    super.key,
  });

  final FormDeleteMaintenanceViewParam param;

  @override
  State<FormDeleteMaintenanceView> createState() =>
      _FormDeleteMaintenanceViewState();
}

class _FormDeleteMaintenanceViewState extends State<FormDeleteMaintenanceView> {
  final ScrollController buktiFotoController = ScrollController();
  final ScrollController buktiVideoController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModel<FormDeleteMaintenanceViewModel>(
      model: FormDeleteMaintenanceViewModel(
        dioService: Provider.of<DioService>(context),
        maintenanceData: widget.param.maintenanceData,
      ),
      onModelReady: (FormDeleteMaintenanceViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Konfirmasi Hapus Pemeliharaan",
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

                  if (model.busy) return;

                  buildLoadingDialog(context);
                  bool result = await model.requestDeleteMaintenanceDate();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Hapus Data Pemeliharaan",
                    description: result
                        ? "Anda telah berhasil menghapus data pemeliharaan ini"
                        : model.errorMsg ??
                            "Anda gagal mengapus data pemeliharaan ini. Coba beberapa saaat lagi.",
                    isSuccessDialog: result,
                    positiveLabel: "Okay",
                    positiveCallback: () {
                      if (result) {
                        Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pop(true);
                        return;
                      }

                      model.resetErrorMsg();
                      Navigator.maybePop(context);
                    },
                  );
                },
                negativeCallback: () {
                  Navigator.maybePop(context);
                },
              );
            },
            text: 'Lanjutkan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                Text(
                  "Mengapa anda ingin menghapus data pemeliharaan ini?",
                  textAlign: TextAlign.center,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor: MyColors.yellow01,
                    fontWeight: 600,
                  ),
                ),
                Spacings.vert(24),
                RadioGroup<String>.builder(
                  groupValue: model.selectedReason,
                  onChanged: (value) => setState(() {
                    model.setSelectedReason(value ?? "");
                  }),
                  items: model.reasonItems,
                  textStyle: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 500,
                  ),
                  fillColor: MyColors.lightBlack02,
                  activeColor: MyColors.yellow01,
                  horizontalAlignment: MainAxisAlignment.spaceEvenly,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
                Spacings.vert(32),
                if (model.selectedReason == "Lainnya") ...[
                  TextInput.editable(
                    onChangedListener: (text) {},
                    label: "Alasan Lainnya",
                    hintText: "Tulis alasan anda disini..",
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  Spacings.vert(24),
                ],
                Text(
                  "Dengan mengisi dan menekan tombol \"Hapus Data Pemeliharaan\" berarti anda mengkonfirmasi untuk menghapus data pemeliharaan ini",
                  textAlign: TextAlign.center,
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.yellow01,
                    fontWeight: 500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
