import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListCustomerViewModel extends BaseViewModel {
  ListCustomerViewModel({
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;

  bool isLoading = false;

  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool _isAllowedToExportData = false;
  bool get isAllowedToExportData => _isAllowedToExportData;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Filter related
  int _selectedTipePelangganOption = 0;
  int get selectedTipePelangganOption => _selectedTipePelangganOption;
  final List<FilterOption> _tipePelangganOptions = [
    FilterOption("Perorangan", true),
    FilterOption("Perusahaan", false),
  ];
  List<FilterOption> get tipePelangganOptions => _tipePelangganOptions;

  int _selectedSumberDataOption = 0;
  int get selectedSumberDataOption => _selectedSumberDataOption;
  final List<FilterOption> _sumberDataOptions = [
    FilterOption("Lead", true),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get sumberDataOptions => _sumberDataOptions;

  int _selectedKebutuhanPelangganOption = 0;
  int get selectedKebutuhanPelangganOption => _selectedKebutuhanPelangganOption;
  final List<FilterOption> _kenbutuhanPelangganOptions = [
    FilterOption("Pembelian Unit", true),
    FilterOption("Perawatan/Troubleshooting", false),
  ];
  List<FilterOption> get kenbutuhanPelangganOptions =>
      _kenbutuhanPelangganOptions;

  int _selectedSortOption = 0;
  int get selectedSortOption => _selectedSortOption;
  final List<FilterOption> _sortOptions = [
    FilterOption("Ascending", true),
    FilterOption("Descending", false),
  ];
  List<FilterOption> get sortOptions => _sortOptions;
  // End of filter related

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

    _isAllowedToExportData = await isUserAllowedToExportData();

    setBusy(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<bool> isUserAllowedToExportData() async {
    Role role = await _authenticationService.getUserRole();
    return role == Role.Admin;
  }

  void terapkanFilter({
    required int selectedPelanggan,
    required int selectedSumberData,
    required int selectedKebutuhanPelanggan,
    required int selectedSort,
    bool needSync = true,
  }) {
    _selectedTipePelangganOption = selectedPelanggan;
    _selectedSumberDataOption = selectedSumberData;
    _selectedKebutuhanPelangganOption = selectedKebutuhanPelanggan;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _tipePelangganOptions.length; i++) {
      if (i == selectedPelanggan) {
        _tipePelangganOptions[i].isSelected = true;
        continue;
      }
      _tipePelangganOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sumberDataOptions.length; i++) {
      if (i == selectedSumberData) {
        _sumberDataOptions[i].isSelected = true;
        continue;
      }
      _sumberDataOptions[i].isSelected = false;
    }

    for (int i = 0; i < _kenbutuhanPelangganOptions.length; i++) {
      if (i == selectedKebutuhanPelanggan) {
        _kenbutuhanPelangganOptions[i].isSelected = true;
        continue;
      }
      _kenbutuhanPelangganOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sortOptions.length; i++) {
      if (i == selectedSort) {
        _sortOptions[i].isSelected = true;
        continue;
      }
      _sortOptions[i].isSelected = false;
    }

    if (needSync) {
      resetPage();
      resetSearchBar();
      syncFilterCustomer();
    }
    notifyListeners();
  }

  void resetSearchBar() {
    searchController.text = "";
  }

  void resetFilter() {
    terapkanFilter(
      selectedKebutuhanPelanggan: 0,
      selectedPelanggan: 0,
      selectedSort: 0,
      selectedSumberData: 0,
      needSync: false,
    );
  }

  Future<void> searchOnChanged(String text) async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      await requestGetAllCustomer();

      isLoading = false;
      return;
    }

    invokeDebouncer(
      () {
        resetPage();
        resetFilter();
        searchCustomer();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (searchController.text.isNotEmpty) {
      invokeDebouncer(searchCustomer);
      return;
    }

    await requestGetAllCustomer();
  }

  void resetPage() {
    _listCustomer = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<void> syncFilterCustomer() async {
    setBusy(true);

    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      setBusy(false);
      return;
    }

    final response = await _apiService.requestFilterCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
      _selectedTipePelangganOption,
      _selectedSumberDataOption,
      _selectedKebutuhanPelangganOption,
      _selectedSortOption,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listCustomer = response.right.result;
        } else {
          _listCustomer?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );
      }
      _isShowNoDataFoundPage = response.right.result.isEmpty;
      setBusy(false);
      notifyListeners();

      return;
    }

    _errorMsg = response.left.message;
    setBusy(false);
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
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listCustomer = response.right.result;
        } else {
          _listCustomer?.addAll(response.right.result);
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

    _listCustomer = [];
    _errorMsg = null;
    resetFilter();

    _paginationControl.currentPage = 1;

    await requestGetAllCustomer();
    _isShowNoDataFoundPage =
        _listCustomer?.isEmpty == true || _listCustomer == null;
    notifyListeners();

    setBusy(false);
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
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listCustomer = response.right.result;
        } else {
          _listCustomer?.addAll(response.right.result);
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
