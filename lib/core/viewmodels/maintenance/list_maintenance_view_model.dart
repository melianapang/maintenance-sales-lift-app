import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListMaintenanceViewModel extends BaseViewModel {
  ListMaintenanceViewModel({
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

  List<GroupingMaintenanceData>? _listMaintenance;
  List<GroupingMaintenanceData>? get listMaintenance => _listMaintenance;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool _isAllowedToExportData = false;
  bool get isAllowedToExportData => _isAllowedToExportData;

  //region search
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  //endregion

  // Filter related
  int _selectedMaintenanceStatusOption = 0;
  int get selectedMaintenanceStatusOption => _selectedMaintenanceStatusOption;
  final List<FilterOption> _maintenanceStatusOptions = [
    FilterOption("Belum Perawatan", true),
    FilterOption("Gagal/Batal", false),
    FilterOption("Selesai", false),
  ];
  List<FilterOption> get maintenanceStatusOptions => _maintenanceStatusOptions;

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

    await requestGetAllMaintenance();

    _isShowNoDataFoundPage =
        _listMaintenance?.isEmpty == true || _listMaintenance == null;
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

  Future<void> searchOnChanged() async {
    isLoading = true;
    invokeDebouncer(
      () async {
        resetPage();
        await requestGetAllMaintenance();
        isLoading = false;
      },
    );
  }

  void terapkanFilter({
    required int selectedMaintenanceStatus,
    required int selectedSort,
    bool needSync = true,
  }) {
    _selectedMaintenanceStatusOption = selectedMaintenanceStatus;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _maintenanceStatusOptions.length; i++) {
      if (i == selectedMaintenanceStatus) {
        _maintenanceStatusOptions[i].isSelected = true;
        continue;
      }
      _maintenanceStatusOptions[i].isSelected = false;
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

      resetPage();
      requestGetAllMaintenance();

      isLoading = false;
    }
    notifyListeners();
  }

  void resetFilter() {
    terapkanFilter(
      selectedMaintenanceStatus: 0,
      selectedSort: 0,
      needSync: false,
    );
  }

  void resetPage() {
    _listMaintenance = [];
    _errorMsg = null;
  }

  Future<void> requestGetAllMaintenance() async {
    final response = await _apiService.requestGetAllMaintenance(
      sortBy: _selectedSortOption,
      status: _selectedMaintenanceStatusOption,
      inputSearch: searchController.text,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        _listMaintenance = response.right.result;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    resetFilter();

    await requestGetAllMaintenance();
    _isShowNoDataFoundPage =
        _listMaintenance?.isEmpty == true || _listMaintenance == null;
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
