import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ChooseCustomerBottomSheetViewModel extends BaseViewModel {
  ChooseCustomerBottomSheetViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  int? _selectedCustomer;
  int? get selectedCustomer => _selectedCustomer;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool isLoading = false;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllCustomer();
    _isShowNoDataFoundPage =
        _listCustomer?.isEmpty == true || _listCustomer == null;
    notifyListeners();

    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void setSelectedCustomer(int index) {
    _selectedCustomer = index;
    notifyListeners();
  }

  Future<void> requestGetAllCustomer() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.getAllCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listCustomer = response.right.result;
      } else {
        _listCustomer?.addAll(response.right.result);
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

  Future<void> searchCustomer() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.searchCustomer(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listCustomer = response.right.result;
      } else {
        _listCustomer?.addAll(response.right.result);
      }

      if (response.right.result.isNotEmpty) {
        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();

      return;
    }

    _errorMsg = response.left.message;
    _isShowNoDataFoundPage = true;
    notifyListeners();
  }

  Future<void> searchOnChanged() async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllCustomer();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () async {
        resetPage();
        await searchCustomer();
        isLoading = false;
      },
    );
  }

  void resetPage() {
    _listCustomer = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  void invokeDebouncer(Function() function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(
        milliseconds: 300,
      ),
      function,
    );
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();

    await requestGetAllCustomer();
    _isShowNoDataFoundPage =
        _listCustomer?.isEmpty == true || _listCustomer == null;
    notifyListeners();

    setBusy(false);
  }
}
