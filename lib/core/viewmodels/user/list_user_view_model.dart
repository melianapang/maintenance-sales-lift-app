import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListUserViewModel extends BaseViewModel {
  ListUserViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  bool isLoading = false;

  List<UserData> _listUser = [];
  List<UserData> get listUser => _listUser;

  //Filter Related
  bool _isFilterActivated = false;

  int _selectedRoleOption = 0;
  int get selectedRoleOption => _selectedRoleOption;
  final List<FilterOption> _roleOptions = [
    FilterOption("Super Admin", false),
    FilterOption("Admin", false),
    FilterOption("Sales", false),
    FilterOption("Teknisi", false),
    FilterOption("All", true),
  ];
  List<FilterOption> get roleOptions => _roleOptions;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _paginationControl.currentPage = 1;
    await requestGetAllUserData();

    _isShowNoDataFoundPage = _listUser.isEmpty;
    notifyListeners();

    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> terapkanFilter({
    required int selectedRole,
    bool needSync = true,
  }) async {
    _selectedRoleOption = selectedRole;
    for (int i = 0; i < _roleOptions.length; i++) {
      if (i == selectedRole) {
        _roleOptions[i].isSelected = true;
        continue;
      }
      _roleOptions[i].isSelected = false;
    }

    //"all" filter is equal with get data in the first time open the page
    if (_selectedRoleOption > 3) {
      isLoading = true;

      _isFilterActivated = false;
      resetPage();
      resetSearchBar();
      _paginationControl.currentPage = 1;
      await requestGetAllUserData();

      isLoading = false;
      notifyListeners();

      return;
    }

    if (needSync) {
      isLoading = true;

      _isFilterActivated = true;
      resetPage();
      resetSearchBar();
      syncFilterUser();

      isLoading = false;
    }
    notifyListeners();
  }

  void resetSearchBar() {
    searchController.text = "";
  }

  Future<void> resetFilter() async {
    _isFilterActivated = false;
    await terapkanFilter(
      selectedRole: 0,
      needSync: false,
    );
  }

  Future<void> syncFilterUser() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.filterUser(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      roleId: _selectedRoleOption + 1,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listUser = response.right.result;
      } else {
        _listUser.addAll(response.right.result);
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
  }

  Future<void> searchOnChanged() async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllUserData();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () async {
        resetPage();
        await searchUser();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    isLoading = false;
    if (_isFilterActivated) {
      await syncFilterUser();

      isLoading = false;
      return;
    }

    if (searchController.text.isNotEmpty) {
      invokeDebouncer(searchUser);
      return;
    }

    await requestGetAllUserData();
  }

  Future<void> requestGetAllUserData() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestGetAllUser(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listUser = response.right.result;
      } else {
        _listUser.addAll(response.right.result);
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
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    await resetFilter();

    await requestGetAllUserData();
    _isShowNoDataFoundPage = _listUser.isEmpty;
    notifyListeners();

    setBusy(false);
  }

  void resetPage() {
    _listUser = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> searchUser() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.searchUser(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listUser = response.right.result;
      } else {
        _listUser.addAll(response.right.result);
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
