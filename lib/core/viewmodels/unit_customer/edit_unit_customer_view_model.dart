import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

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

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    handleAvailableData();

    paginationControl.currentPage = 1;

    await requestGetAllProjectByCustomerId();
    if (_listProject?.isEmpty == true || _listProject == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }

  void handleAvailableData() {
    namaUnitController.text = unitData?.unitName ?? "";
    lokasiUnitController.text = unitData?.unitLocation ?? "";
    _selectedProyek = ProjectData(
      projectId: unitData?.projectId ?? "",
      projectNeed: "",
      projectName: unitData?.projectName ?? "",
      address: "",
      city: "",
      customerId: "",
      customerName: "",
      pics: [],
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

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProyek = _listProject?[selectedIndex];
    notifyListeners();
  }

  bool isValid() {
    _isNamaValid = namaUnitController.text.isNotEmpty;
    _isLocationValid = lokasiUnitController.text.isNotEmpty;
    notifyListeners();

    return _isNamaValid && _isLocationValid;
  }

  Future<void> requestGetAllProjectByCustomerId() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestGetAllProjectsByCustomerId(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listProject = response.right.result;
        } else {
          _listProject?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        notifyListeners();
      }
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
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
