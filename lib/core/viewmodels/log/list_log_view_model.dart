import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListLogViewModel extends BaseViewModel {
  ListLogViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool isLoading = false;

  List<LogData>? _listLogData;
  List<LogData>? get listLogData => _listLogData;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool _isSortAscending = true;
  bool get isNowSortAscending => _isSortAscending;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    await refreshPage();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void resetPage() {
    _listLogData = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> searchOnChanged() async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllLog();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () async {
        resetPage();
        await searchLog();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (searchController.text.isNotEmpty || !isNowSortAscending) {
      invokeDebouncer(searchLog);
      return;
    }

    await requestGetAllLog();
  }

  Future<bool> requestGetAllLog() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return false;
    }

    final response = await _apiService.requestGetAllLog(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listLogData = response.right.result;
        } else {
          _listLogData?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        notifyListeners();
      }
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    await requestGetAllLog();

    _isShowNoDataFoundPage =
        _listLogData?.isEmpty == true || _listLogData == null;
    notifyListeners();

    setBusy(false);
  }

  Future<void> requestSortAscDesc() async {
    resetPage();
    _isSortAscending = !isNowSortAscending;
    searchLog();
    // notifyListeners();
  }

  Future<void> searchLog() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.searchLog(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
      sortBy: _isSortAscending ? "ASC" : "DESC",
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listLogData = response.right.result;
        } else {
          _listLogData?.addAll(response.right.result);
        }

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

  void invokeDebouncer(Function() function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(
        milliseconds: 500,
      ),
      function,
    );
  }
}
