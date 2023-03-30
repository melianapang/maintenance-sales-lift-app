import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:intl/intl.dart';

class FormSetReminderViewModel extends BaseViewModel {
  FormSetReminderViewModel({
    required OneSignalService oneSignalService,
  }) : _oneSignalService = oneSignalService;

  final OneSignalService _oneSignalService;

  // Filter related
  int _selectedSetReminderForOption = 0;
  int get selectedSetReminderForOption => _selectedSetReminderForOption;
  final List<FilterOption> _setReminderForOption = [
    FilterOption("Konfirmasi Pertama", true),
    FilterOption("Konfirmasi Kedua", false),
    FilterOption("Konfirmasi Ketiga", false),
    FilterOption("Nego", false),
    FilterOption("Instalasi", false),
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get setReminderForOption => _setReminderForOption;
  // End of filter related

  String _notificationDescription = "";
  String get notificationDescription => _notificationDescription;

  String _reminderNote = "";
  String get reminderNote => _reminderNote;

  DateTime _selectedTime = DateTime.now();
  DateTime get selectedTime => _selectedTime;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  @override
  Future<void> initModel() async {}

  void setHasilKonfirmasi(int index) {
    _selectedSetReminderForOption = index;
    for (int i = 0; i < _setReminderForOption.length; i++) {
      if (i == _selectedSetReminderForOption) {
        _setReminderForOption[i].isSelected = true;
        continue;
      }
      _setReminderForOption[i].isSelected = false;
    }
    notifyListeners();
  }

  void setDescriptionNotification(String value) {
    _notificationDescription = value;
  }

  void setReminderNote(String value) {
    _reminderNote = value;
  }

  void setSelectedTime(DateTime value) {
    _selectedTime = value;
    notifyListeners();
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }

  Future<void> requestSetReminder() async {
    String timeStr = DateTimeUtils.convertHmsTimeToString(_selectedTime);
    // timeStr = "$timeStr GMT+0700";

    String dateStr = DateTimeUtils.convertDateToString(
      date: selectedDates.first,
      formatter: DateFormat('yyyy-MM-dd'),
    );

    final DateTime reminderSetAt = DateTime.parse("$dateStr $timeStr");

    await _oneSignalService.postNotification(
        description: _notificationDescription,
        note: _reminderNote,
        date: reminderSetAt,
        time: timeStr);
  }
}
