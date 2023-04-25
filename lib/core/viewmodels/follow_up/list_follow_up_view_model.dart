import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListFollowUpViewModel extends BaseViewModel {
  ListFollowUpViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool isLoading = false;

  List<FollowUpFrontData> _listFollowUp = [];
  List<FollowUpFrontData> get listFollowUp => _listFollowUp;

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

    await requestGetAllFollowUp();
    _isShowNoDataFoundPage = _listFollowUp.isEmpty == true;
    notifyListeners();

    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void resetPage() {
    _listFollowUp = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> searchOnChanged() async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllFollowUp();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () async {
        resetPage();
        await searchFollowUp();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (searchController.text.isNotEmpty) {
      invokeDebouncer(searchFollowUp);
      return;
    }

    await requestGetAllFollowUp();
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    await requestGetAllFollowUp();
    _isShowNoDataFoundPage = _listFollowUp.isEmpty == true;
    notifyListeners();

    setBusy(false);
  }

  Future<void> requestGetAllFollowUp() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    _errorMsg = null;

    final response = await _apiService.requestGetAllFollowUp(
      pageSize: _paginationControl.pageSize,
      currentPage: _paginationControl.currentPage,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listFollowUp = response.right.result;
        } else {
          _listFollowUp.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        _isShowNoDataFoundPage = _listFollowUp.isEmpty == true;

        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> searchFollowUp() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.searchFollowUp(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listFollowUp = response.right.result;
        } else {
          _listFollowUp.addAll(response.right.result);
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
