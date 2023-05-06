import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/form_set_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/time_picker.dart';

enum FormSetReminderSource { ListReminderPage, CustomerPage, ProjectPage }

class FormSetReminderViewParam {
  FormSetReminderViewParam({
    required this.source,
    this.customerData,
  });

  final FormSetReminderSource source;
  CustomerData? customerData;
}

class FormSetReminderView extends StatefulWidget {
  const FormSetReminderView({
    required this.param,
    super.key,
  });

  final FormSetReminderViewParam param;

  @override
  State<FormSetReminderView> createState() => _FormSetReminderViewState();
}

class _FormSetReminderViewState extends State<FormSetReminderView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<FormSetReminderViewModel>(
      model: FormSetReminderViewModel(
        dioService: Provider.of<DioService>(context),
        oneSignalService: Provider.of<OneSignalService>(context),
        customerData: widget.param.customerData,
      ),
      onModelReady: (FormSetReminderViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Form Pengingat",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
            buttonType: ButtonType.primary,
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              top: 24,
              left: 24.0,
              right: 24.0,
            ),
            onTap: () async {
              print(
                  "save: ${model.selectedTime.toString()} -- ${model.selectedDates.toString()}");

              buildLoadingDialog(context);
              bool result = await model.requestCreateReminder();
              Navigator.pop(context);

              if (result) {
                Navigator.pushNamed(context, Routes.afterSetReminder);
                return;
              }

              showDialogWidget(
                context,
                title: "Menambahkan Pengingat",
                description: model.errorMsg ?? "Gagal menambahkan penginat",
                isSuccessDialog: result,
                positiveLabel: "Okay",
                positiveCallback: () => Navigator.pop(context),
                negativeLabel: model.errorMsg ==
                        "Tolong ijinkan aplikasi mengakses notifikasi"
                    ? "Buka pengaturan aplikasi."
                    : null,
                negativeCallback: model.errorMsg ==
                        "Tolong ijinkan aplikasi mengakses notifikasi"
                    ? () {
                        openAppSettings();
                        Navigator.maybePop(context);
                      }
                    : null,
              );
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.param.source !=
                    FormSetReminderSource.ListReminderPage) ...[
                  Text(
                    "Informasi Pelanggan",
                    style: buildTextStyle(
                      fontSize: 18,
                      fontColor: MyColors.yellow01,
                      fontWeight: 600,
                    ),
                  ),
                  Spacings.vert(8),
                  TextInput.editable(
                    controller: model.nomorPelangganController,
                    label: "Nomor Pelanggan",
                    hintText: "Nomor Pelanggan",
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.namaPelangganController,
                    label: "Nama Pelanggan",
                    hintText: "Nama Pelanggan",
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    controller: model.namaPerusahaanController,
                    label: "Nama Perusahaan",
                    hintText: "Nama Perusahaan",
                  ),
                  Spacings.vert(12),
                  const Divider(
                    thickness: 1,
                    color: MyColors.darkGreyBackground,
                  ),
                  Spacings.vert(12),
                  Text(
                    "Data Pengingat",
                    style: buildTextStyle(
                      fontSize: 18,
                      fontColor: MyColors.yellow01,
                      fontWeight: 600,
                    ),
                  ),
                  Spacings.vert(8),
                ],
                DatePickerWidget(
                  label: "Tanggal Pengingat",
                  isRangeCalendar: false,
                  selectedDates: model.selectedDates,
                  onSelectedDates: (DateTime start, DateTime? end) {
                    print('$start $end');
                    model.setSelectedDates([start]);
                  },
                ),
                Spacings.vert(24),
                TimePickerWidget(
                  label: "Waktu Pengingat",
                  selectedDateTime: model.selectedTime,
                  onSelectedTime: (DateTime time) {
                    print('$time');
                    model.setSelectedTime(time);
                  },
                ),
                Spacings.vert(24),
                TextInput.editable(
                  controller: model.descriptionController,
                  label: "Deskripsi Pengingat",
                  hintText: "Mengingatkan untuk konfirmasi harga..",
                  note:
                      "NB: Deskripsi ini akan ditampilkan pada notifikasi pengingat. (Max. 100 karakter)",
                  maxLength: 100,
                  onChangedListener: model.onChangedDescription,
                  errorText: !model.isDescriptionValid
                      ? "Kolom ini wajib diisi."
                      : null,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  controller: model.noteController,
                  label: "Catatan",
                  hintText: "Tulis catatan disini...",
                  maxLines: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
