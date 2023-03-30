import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/form_set_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
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
              await model.requestSetReminder();
              Navigator.pushReplacementNamed(context, Routes.afterSetReminder);
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                if (widget.param.source !=
                    FormSetReminderSource.ListReminderPage) ...[
                  TextInput.editable(
                    onChangedListener: (text) {},
                    label: "Nomor Pelanggan",
                    hintText: "Nomor Pelanggan",
                    text: model.customerData?.customerNumber,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    onChangedListener: (text) {},
                    label: "Nama Pelanggan",
                    hintText: "Nama Pelanggan",
                    text: model.customerData?.customerName,
                  ),
                  Spacings.vert(24),
                  TextInput.editable(
                    onChangedListener: (text) {},
                    label: "Nama Perusahaan",
                    hintText: "Nama Perusahaan",
                    text: model.customerData?.companyName,
                  ),
                  Spacings.vert(24),
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
                  label: "Deskripsi Pengingat",
                  hintText: "Mengingatkan untuk konfirmasi harga..",
                  text: model.notificationDescription,
                  onChangedListener: (text) {
                    model.setDescriptionNotification(text);
                  },
                  note:
                      "NB: Deskripsi ini akan ditampilkan pada notifikasi pengingat. (Max. 100 karakter)",
                  maxLength: 100,
                ),
                Spacings.vert(24),
                TextInput.multiline(
                  label: "Catatan",
                  hintText: "Tulis catatan disini...",
                  text: model.reminderNote,
                  onChangedListener: (text) {
                    model.setReminderNote(text);
                  },
                  maxLines: 5,
                  minLines: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
