import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListCustomerNeedViewModel extends BaseViewModel {
  ListCustomerNeedViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool _isAddingNewData = false;
  bool get isAddingNewData => _isAddingNewData;

  final namaKeperluanController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  List<CustomerNeedData>? _listCustomerNeed;
  List<CustomerNeedData>? get listCustomerNeed => _listCustomerNeed;

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
    await requestGetAllCustomerNeed();
    setBusy(false);
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  bool isValid() {
    _isNameValid = namaKeperluanController.text.isNotEmpty;
    return _isNameValid;
  }

  void setIsAddingNewData() {
    _isAddingNewData = !_isAddingNewData;
    notifyListeners();
  }

  Future<void> refreshPage() async {
    resetPage();
    await requestGetAllCustomerNeed();
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void resetPage() {
    _listCustomerNeed = [];
    resetErrorMsg();

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<bool> requestGetAllCustomerNeed() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return false;
    }
    resetErrorMsg();

    final response = await _apiService.getAllCustomerNeed(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      List<CustomerNeedData> tempList = response.right.result;
      if (tempList.isNotEmpty) {
        tempList.where((element) => element.isActive == "1").toList();
      }

      if (_paginationControl.currentPage == 1) {
        _listCustomerNeed = tempList;
      } else {
        _listCustomerNeed?.addAll(tempList);
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

  Future<bool> requestCreateCustomerNeed() async {
    if (!isValid()) {
      _errorMsg = "Isi data dengan benar.";
      return false;
    }
    resetErrorMsg();

    final response = await _apiService.requestCreateCustomerNeed(
      name: namaKeperluanController.text,
    );

    if (response.isRight) {
      namaKeperluanController.text = "";
      setIsAddingNewData();
      await refreshPage();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestDeleteCustomerNeed(int index) async {
    resetErrorMsg();

    final response = await _apiService.requestDeleteCustomerNeed(
      customerNeedId:
          int.parse(_listCustomerNeed?[index].customerNeedId ?? "0"),
    );

    if (response.isRight) {
      await refreshPage();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }
}
