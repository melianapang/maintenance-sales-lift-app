import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({
    required this.label,
    required this.selectedDateTime,
    required this.onSelectedTime,
    super.key,
  });

  final String label;
  final DateTime selectedDateTime;
  final void Function(DateTime) onSelectedTime;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  DateTime? _dateTime;

  @override
  void initState() {
    _dateTime = widget.selectedDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextInput.disabled(
            label: widget.label,
            hintText: "Pilih waktu sesuai keinginan",
            text: _dateTime != null ? convertTimeToString(_dateTime!) : "",
          ),
        ),
        GestureDetector(
          onTap: () async {
            DatePicker.showPicker(
              context,
              showTitleActions: true,
              theme: DatePickerTheme(
                backgroundColor: MyColors.darkBlack02,
                itemStyle: buildTextStyle(
                  fontSize: 16,
                  fontWeight: 600,
                  fontColor: MyColors.lightBlack02,
                ),
                doneStyle: buildTextStyle(
                  fontSize: 16,
                  fontColor: MyColors.yellow01,
                  fontWeight: 400,
                ),
                cancelStyle: buildTextStyle(
                  fontSize: 15,
                  fontColor: MyColors.lightBlack02,
                  fontWeight: 400,
                ),
              ),
              onConfirm: (date) {
                setState(() {
                  _dateTime = date;
                  widget.onSelectedTime(date);
                });
              },
              pickerModel: CustomPicker(
                currentTime: DateTime.now(),
              ),
              locale: LocaleType.id,
            );
          },
          child: Align(
            child: Container(
              margin: const EdgeInsets.only(
                left: 5,
                top: 25,
              ),
              decoration: BoxDecoration(
                color: MyColors.darkBlack02,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 60,
              height: 60,
              child: const Icon(
                PhosphorIcons.timerBold,
                color: MyColors.yellow01,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String convertTimeToString(DateTime pickedTime) {
    return DateFormat.Hm().format(pickedTime);
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
