import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormFollowUpViewModel extends BaseViewModel {
  FormFollowUpViewModel({
    CustomerData? customerData,
    required DioService dioService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _sharedPreferenceService = sharedPreferencesService,
        _customerData = customerData;

  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferenceService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  // Filter related
  int _selectedHasilKonfirmasiOption = 0;
  int get selectedHasilKonfirmasiOption => _selectedHasilKonfirmasiOption;
  final List<FilterOption> _hasilKonfirmasiOption = [
    FilterOption("Loss", true),
    FilterOption("Win", false),
    FilterOption("Hot", false),
    FilterOption("In Progress", false),
  ];
  List<FilterOption> get hasilKonfirmasiOption => _hasilKonfirmasiOption;
  // End of filter related

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  final noteController = TextEditingController();

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }

  void setHasilKonfirmasi(int index) {
    _selectedHasilKonfirmasiOption = index;
    for (int i = 0; i < _hasilKonfirmasiOption.length; i++) {
      if (i == _selectedHasilKonfirmasiOption) {
        _hasilKonfirmasiOption[i].isSelected = true;
        continue;
      }
      _hasilKonfirmasiOption[i].isSelected = false;
    }
    notifyListeners();
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }

  Future<bool> requestUpdateFollowUp() async {
    final response = await _apiService.requestCreateFollowUp(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      followUpResult: _selectedHasilKonfirmasiOption,
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
      note: noteController.text,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
