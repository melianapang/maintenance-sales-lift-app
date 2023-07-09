import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditUnitCustomerViewModel extends BaseViewModel {
  EditUnitCustomerViewModel({
    CustomerData? customerData,
    UnitData? unitData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData,
        _unitData = unitData;

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  UnitData? _unitData;
  UnitData? get unitData => _unitData;

  final namaUnitController = TextEditingController();
  final lokasiUnitController = TextEditingController();

  bool _isNamaValid = true;
  bool get isNamaValid => _isNamaValid;

  bool _isLocationValid = true;
  bool get isLocationValid => _isLocationValid;

  //region pilih proyek
  List<ProjectData>? _listProject;
  List<ProjectData>? get listProject => _listProject;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  ProjectData? _selectedProyek;
  ProjectData? get selectedProyek => _selectedProyek;
  //endregion

  // Dropdown related
  int _selectedTipeUnitOption = 0;
  int get selectedTipeUnitOption => _selectedTipeUnitOption;
  final List<FilterOption> _tipeUnitOptions = [
    FilterOption("Lift Barang", true),
    FilterOption("Lift Penumpang", false),
    FilterOption("Dumbwaiter", false),
    FilterOption("Escalator", false),
    FilterOption("Lift Hydraulic", false),
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

  final jenisUnitController = TextEditingController();
  final tipeUnitController = TextEditingController();
  final kapasitasController = TextEditingController();
  final speedController = TextEditingController();
  final totalLantaiController = TextEditingController();

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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    handleAvailableData();

    paginationControl.currentPage = 1;

    await requestGetAllProjectByCustomerId();

    setBusy(false);
  }

  void handleAvailableData() {
    namaUnitController.text = _unitData?.unitName ?? "";
    lokasiUnitController.text = _unitData?.unitLocation ?? "";
    kapasitasController.text = _unitData?.kapasitas ?? "";
    speedController.text = _unitData?.speed ?? "";
    totalLantaiController.text = _unitData?.totalLantai ?? "";
    _selectedProyek = ProjectData(
      projectId: unitData?.projectId ?? "",
      projectNeed: "",
      projectName: unitData?.projectName ?? "",
      address: "",
      city: "",
      customerId: "",
      customerName: "",
      companyName: "",
      pics: [],
      longitude: "0",
      latitude: "0",
      status: "0",
    );
  }

  void onChangedNama(String value) {
    _isNamaValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedLocation(String value) {
    _isLocationValid = value.isNotEmpty;
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

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProyek = _listProject?[selectedIndex];
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

  bool isValid() {
    _isNamaValid = namaUnitController.text.isNotEmpty;
    _isLocationValid = lokasiUnitController.text.isNotEmpty;
    notifyListeners();

    return _isNamaValid && _isLocationValid;
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

  Future<bool> requestUpdateUnit() async {
    if (!isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    final response = await _apiService.requestUpdateUnit(
      unitId: int.parse(_unitData?.unitId ?? "0"),
      customerId: int.parse(
        _customerData?.customerId ?? "0",
      ),
      projectId: int.parse(_selectedProyek?.projectId ?? "0"),
      unitName: namaUnitController.text,
      unitLocation: lokasiUnitController.text,
      jenisUnit:
          _selectedJenisUnitOption == 3 ? null : _selectedJenisUnitOption,
      tipeUnit: _selectedTipeUnitOption,
      speed: double.parse(speedController.text),
      kapasitas: double.parse(kapasitasController.text),
      totalLantai: double.parse(totalLantaiController.text),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestCreateUnit() async {
    final response = await _apiService.requestUpdateUnit(
      unitId: int.parse(unitData?.unitId ?? "0"),
      customerId: int.parse(_customerData?.customerId ?? "0"),
      projectId: int.parse(_selectedProyek?.projectId ?? "0"),
      unitName: namaUnitController.text,
      unitLocation: lokasiUnitController.text,
      jenisUnit:
          _selectedJenisUnitOption == 3 ? null : _selectedJenisUnitOption,
      tipeUnit: _selectedTipeUnitOption,
      speed: double.parse(speedController.text),
      kapasitas: double.parse(kapasitasController.text),
      totalLantai: double.parse(totalLantaiController.text),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
