import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/notification/local_push_notif_payload.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/local_notification_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/notification_handler_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:intl/intl.dart';

class FormSetReminderViewModel extends BaseViewModel {
  FormSetReminderViewModel({
    required LocalNotificationService localNotificationService,
    required OneSignalService oneSignalService,
    required DioService dioService,
    ProjectData? projectData,
    MaintenanceData? maintenanceData,
  })  : _localNotificationService = localNotificationService,
        _oneSignalService = oneSignalService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _projectData = projectData,
        _maintenanceData = maintenanceData;

  final LocalNotificationService _localNotificationService;
  final OneSignalService _oneSignalService;
  final ApiService _apiService;

  final ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  final MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  bool _isNotificationPermissionGrantedBefore = true;

  // TextEditingController
  final namaProyekController = TextEditingController();
  final namaPelangganController = TextEditingController();
  final namaPerusahaanController = TextEditingController();

  final namaUnitController = TextEditingController();
  final lokasiUnitController = TextEditingController();
  final namaPelangganUnitController = TextEditingController();

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

  DateTime _selectedTime = DateTime.now().add(const Duration(
    minutes: 5,
  ));
  DateTime get selectedTime => _selectedTime;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    //if customerData not null
    namaProyekController.text = _projectData?.projectName ?? "";
    namaPelangganController.text = _projectData?.customerName ?? "";
    namaPerusahaanController.text = _projectData?.companyName ?? "";

    //if maintenanceData not null
    namaUnitController.text = _maintenanceData?.unitName ?? "";
    lokasiUnitController.text = _maintenanceData?.unitLocation ?? "";
    namaPelangganUnitController.text = _maintenanceData?.customerName ?? "";
    if (_maintenanceData?.scheduleDate != null) {
      _selectedDates = [
        DateTimeUtils.convertStringToDate(
          formattedDateString: _maintenanceData?.scheduleDate ?? '',
        )
      ];
    }
    setBusy(false);
  }

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

  bool get isValidToCreateReminder {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(_selectedDates.first.year,
        _selectedDates.first.month, _selectedDates.first.day);
    if (selectedDate == today &&
        (_selectedTime.isAtSameMomentAs(now) || _selectedTime.isBefore(now))) {
      return false;
    }
    return true;
  }

  Future<bool> requestCreateReminder() async {
    setBusy(true);

    if (!isValidToCreateReminder) {
      _errorMsg = "Jadwal Pengingat harus lebih dari waktu saat ini.";
      setBusy(false);
      return false;
    }

    bool isGranted = await PermissionUtils.requestPermission(
      Permission.notification,
    );

    if (!isGranted) {
      _errorMsg = "Tolong ijinkan aplikasi mengakses notifikasi";
      _isNotificationPermissionGrantedBefore = false;
      setBusy(false);
      return false;
    }

    //after notification granted, then refresh onesignal
    if (!_isNotificationPermissionGrantedBefore) {
      await _oneSignalService
          .initOneSignal()
          .then((value) => _isNotificationPermissionGrantedBefore = true);
      //sometimes need to wait until the onesignal is cleary refreshed.
      await Future.delayed(const Duration(seconds: 5));

      _errorMsg = null;
    }

    int? projectId = int.parse(_projectData?.projectId ?? "-1");
    String? maintenanceId = _maintenanceData?.maintenanceId ?? "";

    final response = await _apiService.requestCreateReminder(
      projectId: projectId > 0 ? projectId : null,
      maintenanceId: maintenanceId.isEmpty ? null : maintenanceId,
      reminderDate: DateTimeUtils.convertDateToString(
        date: _selectedDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_4,
        ),
      ),
      reminderTime: DateTimeUtils.convertHmsTimeToString(
        _selectedTime,
      ),
      description: descriptionController.text,
      remindedNote: noteController.text,
    );

    if (response.isRight) {
      // bool isSucceed = await requestSetReminderToOneSignal(
      //   reminderId: response.right,
      // );
      // return isSucceed;
      return setLocalScheduledNotification(
        reminderId: response.right,
      );
    }

    _errorMsg = response.left.message;
    setBusy(false);
    return false;
  }

  Future<bool> setLocalScheduledNotification({
    required String reminderId,
  }) async {
    try {
      String timeStr = DateTimeUtils.convertHmsTimeToString(_selectedTime);

      String dateStr = DateTimeUtils.convertDateToString(
        date: selectedDates.first,
        formatter: DateFormat('yyyy-MM-dd'),
      );

      await _localNotificationService.createScheduledNotification(
        description: descriptionController.text,
        date: _selectedDates.first,
        time: _selectedTime,
        type: NotifMessageType.FollowUp,
        payload: LocalPushNotifPayload(
          date: dateStr,
          time: timeStr,
          description: descriptionController.text,
          note: noteController.text,
          reminderId: reminderId,
        ),
      );

      setBusy(false);
      return true;
    } catch (e) {
      _errorMsg = "$e";
      setBusy(false);
      return false;
    }
  }

  Future<bool> requestSetReminderToOneSignal(
      {required String reminderId}) async {
    String timeStr = DateTimeUtils.convertHmsTimeToString(_selectedTime);
    // timeStr = "$timeStr GMT+0700";

    String dateStr = DateTimeUtils.convertDateToString(
      date: selectedDates.first,
      formatter: DateFormat('yyyy-MM-dd'),
    );

    final DateTime reminderSetAt = DateTime.parse("$dateStr $timeStr");
    return false;
    // final response = await _oneSignalService.postNotification(
    //   description: descriptionController.text,
    //   note: noteController.text,
    //   date: reminderSetAt,
    //   time: timeStr,
    //   reminderId: reminderId,
    // );

    // if (response.isRight) {
    //   return true;
    // }

    // _errorMsg = response.left.message;
    // return false;
  }
}
