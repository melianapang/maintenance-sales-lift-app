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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllProjectByCustomerId();

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
      }
      _isShowNoDataFoundPage = response.right.result.isEmpty == true ||
          _listProject?.isEmpty == true ||
          _listProject == null;

      notifyListeners();
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
