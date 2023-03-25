import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({
    required this.label,
    required this.isRangeCalendar,
    required this.selectedDates,
    required this.onSelectedDates,
    super.key,
  });

  final String label;
  final bool isRangeCalendar;
  final List<DateTime> selectedDates;

  /// Left `DateTime` is used for single calendar picker OR start date for range calendar picker. Right `DateTime` is used for end date for range calendar picker.
  final void Function(DateTime, DateTime?) onSelectedDates;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  List<DateTime?> _selectedDates = [];

  TextStyle get dayTextStyle => buildTextStyle(
        fontColor: MyColors.lightBlack02,
        fontWeight: 700,
        fontSize: 14,
      );

  String? _getText(CalendarDatePicker2WithActionButtonsConfig config) {
    if (_selectedDates.isEmpty) return null;
    return _getValueText(config.calendarType, _selectedDates);
  }

  @override
  void initState() {
    _selectedDates = widget.selectedDates;

    if (widget.isRangeCalendar && _selectedDates.length == 1) {
      _selectedDates.add(
        DateTime.now().add(
          const Duration(
            days: 1,
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: widget.isRangeCalendar
          ? CalendarDatePicker2Type.range
          : CalendarDatePicker2Type.single,
      selectedDayHighlightColor: MyColors.yellow01,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabels: ['Ming', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
      weekdayLabelTextStyle: buildTextStyle(
        fontSize: 14,
        fontColor: MyColors.lightBlack02,
        fontWeight: 800,
      ),
      controlsTextStyle: buildTextStyle(
        fontSize: 14,
        fontColor: MyColors.lightBlack02,
        fontWeight: 800,
      ),
      centerAlignModePickerButton: true,
      customModePickerButtonIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(
        color: MyColors.darkBlack01,
      ),
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyColors.yellow01,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return Row(
      children: [
        Expanded(
          child: TextInput.disabled(
            label: widget.label,
            hintText: "Pilih Tanggal sesuai keinginan",
            text: _getText(config),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final values = await showCalendarDatePicker2Dialog(
              context: context,
              config: config,
              dialogSize: const Size(325, 400),
              borderRadius: BorderRadius.circular(15),
              initialValue: _selectedDates,
              dialogBackgroundColor: MyColors.lightBlack01,
            );
            if (values != null) {
              _selectedDates = values;
              if (values.isNotEmpty) {
                setState(() {
                  widget.onSelectedDates(
                    values[0]!,
                    values.length > 1 ? values[1] : null,
                  );
                });
              }
            }
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
                PhosphorIcons.calendarBlankBold,
                color: MyColors.yellow01,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _getValueText(
  CalendarDatePicker2Type datePickerType,
  List<DateTime?> values,
) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  values = values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();

  if (datePickerType == CalendarDatePicker2Type.single) {
    DateTime? valueText = values.isNotEmpty ? values[0] : null;
    return formatter.format(valueText ?? DateTime.now());
  } else if (datePickerType == CalendarDatePicker2Type.multi) {
    return values.isNotEmpty
        ? values
            .map((v) => v.toString().replaceAll('00:00:00.000', ''))
            .join(', ')
        : '';
  } else if (datePickerType == CalendarDatePicker2Type.range) {
    if (values.isNotEmpty) {
      DateTime? startDate = values.isNotEmpty ? values[0] : null;
      String startDateStr = formatter.format(startDate ?? DateTime.now());

      DateTime? endDate = values.length > 1 ? values[1] : null;
      String endDateStr = formatter.format(endDate ?? DateTime.now());
      return '$startDateStr - $endDateStr';
    } else {
      return '';
    }
  } else {
    return '';
  }
}
