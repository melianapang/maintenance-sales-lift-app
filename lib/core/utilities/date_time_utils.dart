import 'package:intl/intl.dart';

class DateTimeUtils {
  static String DATE_FORMAT_1 = "ddMMMyyyy";
  static String DATE_FORMAT_2 = "dd MMM yyyy";

  static String convertHmTimeToString(DateTime pickedTime) {
    return DateFormat.Hm().format(pickedTime);
  }

  static String convertHmsTimeToString(DateTime pickedTime) {
    return DateFormat.Hms().format(pickedTime);
  }

  static String convertDateToString({
    required DateTime date,
    required DateFormat formatter,
  }) {
    return formatter.format(date);
  }

  static DateTime convertStringToDate({required String formattedDateString}) {
    return DateTime.parse(formattedDateString);
  }

  static String convertStringToOtherStringDateFormat({
    required String date,
    required String formattedString,
  }) {
    DateTime convertedDate = convertStringToDate(
      formattedDateString: date,
    );

    return convertDateToString(
      date: convertedDate,
      formatter: DateFormat(
        formattedString,
      ),
    );
  }

  static bool isDateStringAfterToday(String formattedString) {
    return convertStringToDate(formattedDateString: formattedString)
        .isAfter(DateTime.now());
  }

  static bool isDateAfterToday(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static String convertDateTimeNotification(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime.toUtc()) + " GMT";
  }
}
