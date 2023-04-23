import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListReminderViewModel extends BaseViewModel {
  ListReminderViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool isLoading = false;

  List<ReminderData> _listReminder = [];
  List<ReminderData> get listReminder => _listReminder;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllReminderData();
    _isShowNoDataFoundPage = _listReminder.isEmpty;
    notifyListeners();
    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> searchOnChanged(String value) async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllReminderData();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () {
        resetPage();
        searchReminder();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (searchController.text.isNotEmpty) {
      invokeDebouncer(searchReminder);
      return;
    }

    await requestGetAllReminderData();
  }

  void resetPage() {
    _listReminder = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> requestGetAllReminderData() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestGetAllReminder(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listReminder = response.right.result;
        } else {
          _listReminder.addAll(response.right.result);
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

  Future<void> refreshPage() async {
    setBusy(true);

    _listReminder = [];
    _errorMsg = null;

    paginationControl.currentPage = 1;
    await requestGetAllReminderData();

    if (_listReminder.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }

  Future<void> searchReminder() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.searchReminder(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listReminder = response.right.result;
        } else {
          _listReminder.addAll(response.right.result);
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
