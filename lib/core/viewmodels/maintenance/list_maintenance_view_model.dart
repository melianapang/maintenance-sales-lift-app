import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
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

  List<MaintenanceData>? _listMaintenance;
  List<MaintenanceData>? get listMaintenance => _listMaintenance;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool _isAllowedToExportData = false;
  bool get isAllowedToExportData => _isAllowedToExportData;

  // Filter related
  int _selectedMaintenanceStatusOption = 0;
  int get selectedMaintenanceStatusOption => _selectedMaintenanceStatusOption;
  final List<FilterOption> _maintenanceStatusOptions = [
    FilterOption("NOT MAINTENANCE", true),
    FilterOption("DONE", false),
    FilterOption("PENDING", false),
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

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    paginationControl.currentPage = 1;

    await requestGetAllMaintenance();
    if (_listMaintenance?.isEmpty == true || _listMaintenance == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    _isAllowedToExportData = await isUserAllowedToExportData();

    setBusy(false);
  }

  Future<void> requestGetAllMaintenance() async {
    final response = await _apiService.requestGetAllMaintenance(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listMaintenance = response.right;
        } else {
          _listMaintenance?.addAll(response.right!);
        }
        _paginationControl.currentPage += 1;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    _listMaintenance = [];

    paginationControl.currentPage = 1;
    await requestGetAllMaintenance();

    if (_listMaintenance?.isEmpty == true || _listMaintenance == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }

  Future<bool> isUserAllowedToExportData() async {
    Role role = await _authenticationService.getUserRole();
    return role == Role.Admin;
  }

  void terapkanFilter({
    required int selectedHandledBy,
    required int selectedSort,
  }) {
    _selectedMaintenanceStatusOption = selectedHandledBy;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _maintenanceStatusOptions.length; i++) {
      if (i == selectedHandledBy) {
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
    notifyListeners();
  }
}
