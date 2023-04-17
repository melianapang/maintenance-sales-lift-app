import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:intl/intl.dart';

class FormSetReminderViewModel extends BaseViewModel {
  FormSetReminderViewModel({
    required OneSignalService oneSignalService,
    CustomerData? customerData,
  })  : _oneSignalService = oneSignalService,
        _customerData = customerData;

  final OneSignalService _oneSignalService;

  final CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  // TextEditingController
  final nomorPelangganController = TextEditingController();
  final namaPelangganController = TextEditingController();
  final namaPerusahaanController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  // End of TextEditingController

  bool _isDescriptionValid = true;
  bool get isDescriptionValid => _isDescriptionValid;

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

  DateTime _selectedTime = DateTime.now();
  DateTime get selectedTime => _selectedTime;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

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

  void onChangedDescription(String value) {
    _isDescriptionValid = value.isNotEmpty;
    notifyListeners();
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
      description: descriptionController.text,
      note: noteController.text,
      date: reminderSetAt,
      time: timeStr,
    );
  }
}
