import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class AddUnitCustomerViewModel extends BaseViewModel {
  AddUnitCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  int _totalData = -1;
  int get totalData => _totalData;

  List<ProjectData>? _listProject;
  List<ProjectData>? get listProject => _listProject;

  final nameController = TextEditingController();
  final locationController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isLocationValid = true;
  bool get isLocationValid => _isLocationValid;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  ProjectData? _selectedProyek;
  ProjectData? get selectedProyek => _selectedProyek;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllProjectByCustomerId();
    if (_listProject?.isEmpty == true || _listProject == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProyek = _listProject?[selectedIndex];
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

  bool isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isLocationValid = locationController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid && _isLocationValid;
  }

  Future<void> requestGetAllProjectByCustomerId() async {
    if (_totalData != -1 &&
        _totalData <=
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
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listProject = response.right!;
        } else {
          _listProject?.addAll(response.right!);
        }
        _paginationControl.currentPage += 1;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<bool> requestCreateUnit() async {
    final response = await _apiService.requestCreateUnit(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      projectId: int.parse(_selectedProyek?.projectId ?? "0"),
      unitName: nameController.text,
      unitLocation: locationController.text,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
