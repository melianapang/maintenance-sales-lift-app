import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_type_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListCustomerTypeViewModel extends BaseViewModel {
  ListCustomerTypeViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool _isAddingNewData = false;
  bool get isAddingNewData => _isAddingNewData;

  final namaTipeController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  List<CustomerTypeData>? _listCustomerType;
  List<CustomerTypeData>? get listCustomerType => _listCustomerType;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    paginationControl.currentPage = 1;
    await requestGetAllCustomerType();
    setBusy(false);
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  bool isValid() {
    _isNameValid = namaTipeController.text.isNotEmpty;
    return _isNameValid;
  }

  void setIsAddingNewData() {
    _isAddingNewData = !_isAddingNewData;
    notifyListeners();
  }

  Future<void> refreshPage() async {
    resetPage();
    await requestGetAllCustomerType();
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void resetPage() {
    _listCustomerType = [];
    resetErrorMsg();

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<bool> requestGetAllCustomerType() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return false;
    }
    resetErrorMsg();

    final response = await _apiService.getAllCustomerType(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listCustomerType = response.right.result;
      } else {
        _listCustomerType?.addAll(response.right.result);
      }

      if (response.right.result.isNotEmpty == true) {
        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestCreateCustomerType() async {
    if (!isValid()) {
      _errorMsg = "Isi data dengan benar.";
      return false;
    }
    resetErrorMsg();

    final response = await _apiService.requestCreateCustomerTypes(
      name: namaTipeController.text,
    );

    if (response.isRight) {
      namaTipeController.text = "";
      setIsAddingNewData();
      await refreshPage();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestDeleteCustomerType(int index) async {
    resetErrorMsg();

    final response = await _apiService.requestDeleteCustomerType(
      customerTypeId:
          int.parse(_listCustomerType?[index].customerTypeId ?? "0"),
    );

    if (response.isRight) {
      await refreshPage();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }
}
