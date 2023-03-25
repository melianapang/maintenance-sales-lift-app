import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/form_set_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/time_picker.dart';

class FormSetReminderView extends StatefulWidget {
  const FormSetReminderView({super.key});

  @override
  State<FormSetReminderView> createState() => _FormSetReminderViewState();
}

class _FormSetReminderViewState extends State<FormSetReminderView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<FormSetReminderViewModel>(
      model: FormSetReminderViewModel(),
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
            onTap: () {
              print(
                  "save: ${model.selectedTime.toString()} -- ${model.selectedDates.toString()}");
              // Navigator.pushNamed(context, Routes.afterSetReminder);
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nomor Pelanggan",
                  hintText: "Nomor Pelanggan",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nama Pelanggan",
                  hintText: "Nama Pelanggan",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nama Perusahaan",
                  hintText: "Nama Perusahaan",
                ),
                Spacings.vert(24),
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
                TextInput.multiline(
                  onChangedListener: (text) {},
                  label: "Deskripsi Pengingat",
                  hintText: "Mengingatkan untuk konfirmasi harga..",
                  note:
                      "NB: Deskripsi ini akan ditampilkan pada notifikasi pengingat.",
                  maxLines: 2,
                  minLines: 2,
                ),
                Spacings.vert(24),
                TextInput.multiline(
                  onChangedListener: (text) {},
                  label: "Catatan",
                  hintText: "Tulis catatan disini...",
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
