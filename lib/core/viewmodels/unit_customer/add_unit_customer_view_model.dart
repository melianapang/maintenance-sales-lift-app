import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/add_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class AddUnitCustomerViewModel extends BaseViewModel {
  AddUnitCustomerViewModel({
    CustomerType? customerType,
    CustomerData? customerData,
    ProjectData? projectData,
    ListUnitCustomerSourcePage? sourcePageForList,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _isNonProjectCustomer = customerType == CustomerType.NonProjectCustomer,
        _sourcePageForList = sourcePageForList,
        _projectData = projectData,
        _customerData = customerData;

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  List<ProjectData>? _listProject;
  List<ProjectData>? get listProject => _listProject;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  bool _isNonProjectCustomer = false;
  bool get isNonProjectCustomer => _isNonProjectCustomer;

  ListUnitCustomerSourcePage? _sourcePageForList;
  ListUnitCustomerSourcePage? get sourcePageForList => _sourcePageForList;

  bool get isAllowedToChooseProject {
    if (_isNonProjectCustomer ||
        _sourcePageForList == ListUnitCustomerSourcePage.DetailProject) {
      return false;
    }
    return true;
  }

  // Dropdown related
  int _selectedTipeUnitOption = 0;
  int get selectedTipeUnitOption => _selectedTipeUnitOption;
  final List<FilterOption> _tipeUnitOptions = [
    FilterOption("Lift Barang", true),
    FilterOption("Lift Penumpang", false),
    FilterOption("Dumbwaiter", false),
    FilterOption("Escalator", false),
    FilterOption("Lift Hydraulic", false),
    FilterOption("Lift Traction Backpack", false),
    FilterOption("Lain-Lain", false),
  ];
  List<FilterOption> get tipeUnitOptions => _tipeUnitOptions;

  int _selectedJenisUnitOption = 0;
  int get selectedJenisUnitOption => _selectedJenisUnitOption;
  final List<FilterOption> _jenisUnitOptions = [
    FilterOption("MRL", true),
    FilterOption("MR", false),
  ];
  List<FilterOption> get jenisUnitOptions => _jenisUnitOptions;
  //End of Dropdown related

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final jenisUnitController = TextEditingController();
  final tipeUnitController = TextEditingController();
  final kapasitasController = TextEditingController();
  final speedController = TextEditingController();
  final totalLantaiController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isLocationValid = true;
  bool get isLocationValid => _isLocationValid;

  bool _isKapasitasValid = true;
  bool get isKapasitasValid => _isKapasitasValid;

  bool _isSpeedValid = true;
  bool get isSpeedValid => _isSpeedValid;

  bool _isTotalLantaiValid = true;
  bool get isTotalLantaiValid => _isTotalLantaiValid;

  String? get selectedTipeUnitString {
    return _tipeUnitOptions[_selectedTipeUnitOption].title;
  }

  String? get selectedJenisUnitString {
    return _jenisUnitOptions[_selectedJenisUnitOption].title;
  }

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  ProjectData? _selectedProyek;
  ProjectData? get selectedProyek => _selectedProyek;

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
  Future<void> initModel() async {
    setBusy(true);

    if (isAllowedToChooseProject) {
      _paginationControl.currentPage = 1;
      await requestGetAllProjectByCustomerId();
    } else if (_sourcePageForList == ListUnitCustomerSourcePage.DetailProject) {
      _selectedProyek = _projectData;
    }

    setBusy(false);
  }

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProyek = _listProject?[selectedIndex];
    notifyListeners();
  }

  void setSelectedTipeUnit({
    required int selectedMenu,
  }) {
    _selectedTipeUnitOption = selectedMenu;
    for (int i = 0; i < _tipeUnitOptions.length; i++) {
      if (i == selectedMenu) {
        _tipeUnitOptions[i].isSelected = true;
        continue;
      }
      _tipeUnitOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void setSelectedJenisUnit({
    required int selectedMenu,
  }) {
    _selectedJenisUnitOption = selectedMenu;
    for (int i = 0; i < _jenisUnitOptions.length; i++) {
      if (i == selectedMenu) {
        _jenisUnitOptions[i].isSelected = true;
        continue;
      }
      _jenisUnitOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedLocation(String value) {
    _isLocationValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedKapasitas(String value) {
    _isKapasitasValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedSpeed(String value) {
    _isSpeedValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedTotalLantaiController(String value) {
    _isTotalLantaiValid = value.isNotEmpty;
    notifyListeners();
  }

  void setSelectedNextMaintenanceDates(List<DateTime> value) {
    _selectedNextMaintenanceDates = value;
    notifyListeners();
  }

  bool isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isLocationValid = locationController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid && _isLocationValid;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<void> requestGetAllProjectByCustomerId() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    _errorMsg = null;

    final response = await _apiService.requestGetAllProjectsByCustomerId(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listProject = response.right.result;
      } else {
        _listProject?.addAll(response.right.result);
      }

      if (response.right.result.isNotEmpty) {
        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty == true;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<bool> requestCreateUnit() async {
    final response = await _apiService.requestCreateUnit(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      projectId: _isNonProjectCustomer
          ? null
          : int.parse(_selectedProyek?.projectId ?? "0"),
      unitName: nameController.text,
      unitLocation: locationController.text,
      jenisUnit: _selectedJenisUnitOption,
      tipeUnit: _selectedTipeUnitOption,
      speed: double.parse(speedController.text),
      kapasitas: double.parse(kapasitasController.text),
      totalLantai: double.parse(totalLantaiController.text),
      firstMaintenanceDate: DateTimeUtils.convertDateToString(
        date: _selectedNextMaintenanceDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
