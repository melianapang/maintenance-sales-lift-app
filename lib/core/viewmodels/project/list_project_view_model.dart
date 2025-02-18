import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListProjectViewModel extends BaseViewModel {
  ListProjectViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool isLoading = false;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  List<ProjectData> _listProject = [];
  List<ProjectData> get listProject => _listProject;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllProjects();

    _isShowNoDataFoundPage = _listProject.isEmpty == true;
    notifyListeners();

    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> searchOnChanged() async {
    isLoading = true;
    invokeDebouncer(
      () async {
        resetPage();
        await requestGetAllProjects();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    await requestGetAllProjects();
  }

  void resetPage() {
    _listProject = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> requestGetAllProjects() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.getAllProjects(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputSearch: searchController.text,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listProject = response.right.result;
      } else {
        _listProject.addAll(response.right.result);
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

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    await requestGetAllProjects();

    _isShowNoDataFoundPage = _listProject.isEmpty == true;
    notifyListeners();

    setBusy(false);
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
