import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_type_dto.dart';
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
  bool _isFilterActivated = false;

  int? _selectedSumberDataOption;
  int? get selectedSumberDataOption => _selectedSumberDataOption;
  final List<FilterOption> _sumberDataOptions = [
    FilterOption("Lead", false),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get sumberDataOptions => _sumberDataOptions;

  int? _selectedSortOption;
  int? get selectedSortOption => _selectedSortOption;
  final List<FilterOption> _sortOptions = [
    FilterOption("Ascending", false),
    FilterOption("Descending", false),
  ];
  List<FilterOption> get sortOptions => _sortOptions;
  // End of filter related

  //Filter Dynamic (values from API) related
  int? _selectedCustomerNeedFilter;
  int? get selectedCustomerNeedFilter => _selectedCustomerNeedFilter;

  List<CustomerNeedData>? _listCustomerNeed;
  List<CustomerNeedData>? get listCustomerNeed => _listCustomerNeed;
  List<FilterOptionDynamic> customerNeedFilterOptions = [];

  int? _selectedCustomerTypeFilter;
  int? get selectedCustomerTypeFilter => _selectedCustomerTypeFilter;

  List<CustomerTypeData>? _listCustomerType;
  List<CustomerTypeData>? get listCustomerType => _listCustomerType;
  List<FilterOptionDynamic> customerTypeFilterOptions = [];

  //End of filter dynamic related

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllCustomerNeed();
    await requestGetAllCustomerType();
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
    return role == Role.Admin || role == Role.SuperAdmin;
  }

  void convertCustomerTypeDataToFilterData(List<CustomerTypeData> values) {
    if (values.isEmpty) return;

    customerTypeFilterOptions = values
        .map(
          (e) => FilterOptionDynamic(
            e.customerTypeId,
            e.customerTypeName,
            false,
          ),
        )
        .toList();
  }

  void convertCustomerNeedDataToFilterData(List<CustomerNeedData> values) {
    if (values.isEmpty) return;

    customerNeedFilterOptions = values
        .map(
          (e) => FilterOptionDynamic(
            e.customerNeedId,
            e.customerNeedName,
            false,
          ),
        )
        .toList();
  }

  void terapkanFilterMenu({
    required int? selectedPelanggan,
    required int? selectedSumberData,
    required int? selectedKebutuhanPelanggan,
    required int? selectedSort,
    bool needSync = true,
  }) {
    _selectedCustomerTypeFilter = selectedPelanggan;
    _selectedSumberDataOption = selectedSumberData;
    _selectedCustomerNeedFilter = selectedKebutuhanPelanggan;
    _selectedSortOption = selectedSort;

    for (FilterOptionDynamic menu in customerTypeFilterOptions) {
      if (selectedPelanggan == int.parse(menu.idFilter)) {
        menu.isSelected = true;
        continue;
      }
      menu.isSelected = false;
    }

    for (int i = 0; i < _sumberDataOptions.length; i++) {
      if (i == selectedSumberData) {
        _sumberDataOptions[i].isSelected = true;
        continue;
      }
      _sumberDataOptions[i].isSelected = false;
    }

    for (FilterOptionDynamic menu in customerNeedFilterOptions) {
      if (selectedKebutuhanPelanggan == int.parse(menu.idFilter)) {
        menu.isSelected = true;
        continue;
      }
      menu.isSelected = false;
    }

    for (int i = 0; i < _sortOptions.length; i++) {
      if (i == selectedSort) {
        _sortOptions[i].isSelected = true;
        continue;
      }
      _sortOptions[i].isSelected = false;
    }

    if (needSync) {
      isLoading = true;

      _isFilterActivated = true;
      resetPage();
      resetSearchBar();
      syncFilterCustomer();

      isLoading = false;
    }
    notifyListeners();
  }

  void resetFilterMenu() {
    resetFilter();
    resetPage();
    resetSearchBar();
    requestGetAllCustomer();
  }

  void resetSearchBar() {
    searchController.text = "";
  }

  void resetFilter() {
    _isFilterActivated = false;
    terapkanFilterMenu(
      selectedKebutuhanPelanggan: null,
      selectedPelanggan: null,
      selectedSort: null,
      selectedSumberData: null,
      needSync: false,
    );
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
        resetFilter();
        await searchCustomer();
        isLoading = false;
      },
    );
  }

  Future<void> onLazyLoad() async {
    isLoading = false;
    if (_isFilterActivated) {
      await syncFilterCustomer();

      isLoading = false;
      return;
    }

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

  Future<bool> requestGetAllCustomerNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        List<CustomerNeedData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _listCustomerNeed = tempList;
        convertCustomerNeedDataToFilterData(tempList);
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestGetAllCustomerType() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerTypeWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        List<CustomerTypeData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _listCustomerType = tempList;
        convertCustomerTypeDataToFilterData(tempList);
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> syncFilterCustomer() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestFilterCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
      _selectedCustomerTypeFilter,
      _selectedSumberDataOption,
      _selectedCustomerNeedFilter,
      _selectedSortOption,
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

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    resetFilter();

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

  void invokeDebouncer(Function() function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(
        milliseconds: 300,
      ),
      function,
    );
  }
}
