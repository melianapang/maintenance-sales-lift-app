import 'package:intl/intl.dart';

class DateTimeUtils {
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

  static String convertDateTimeNotification(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime.toUtc()) + " GMT";
  }
}
