import 'dart:io';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class FormChangeMaintenanceDateViewModel extends BaseViewModel {
  FormChangeMaintenanceDateViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _maintenanceData = maintenanceData;

  final ApiService _apiService;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  List<DateTime> _selectedNextMaintenanceDates = [
    DateTime.now().add(
      Duration(
        days: 7,
      ),
    ),
  ];
  List<DateTime> get selectedNextMaintenanceDates =>
      _selectedNextMaintenanceDates;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void setSelectedNextMaintenanceDates(List<DateTime> value) {
    _selectedNextMaintenanceDates = value;
    notifyListeners();
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<bool> requestChangeMaintenanceDate() async {
    if (!DateTimeUtils.isDateAfterToday(_selectedNextMaintenanceDates.first)) {
      _errorMsg =
          "Tidak bisa mengubah jadwal dengan tanggal yang sudah berlalu";
      return false;
    }

    final response = await _apiService.requestChangeMaintenanceDate(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedNextMaintenanceDates.first,
        formatter: DateFormat(DateTimeUtils.DATE_FORMAT_3),
      ),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
