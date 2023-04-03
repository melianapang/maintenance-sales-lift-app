import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListMaintenanceViewModel extends BaseViewModel {
  ListMaintenanceViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<MaintenanceData>? _listMaintenance;
  List<MaintenanceData>? get listMaintenance => _listMaintenance;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  // Filter related
  int _selectedHandledByOption = 0;
  int get selectedSumberDataOption => _selectedHandledByOption;
  final List<FilterOption> _handledByOptions = [
    FilterOption("Lead", true),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get handledByOptions => _handledByOptions;

  int _selectedSortOption = 0;
  int get selectedSortOption => _selectedSortOption;
  final List<FilterOption> _sortOptions = [
    FilterOption("Ascending", true),
    FilterOption("Descending", false),
  ];
  List<FilterOption> get sortOptions => _sortOptions;
  // End of filter related

  @override
  Future<void> initModel() async {
    setBusy(true);
    paginationControl.currentPage = 1;

    await requestGetAllMaintenance();
    if (_listMaintenance?.isEmpty == true || _listMaintenance == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }

  Future<void> requestGetAllMaintenance() async {
    List<MaintenanceData>? list = await _apiService.requestGetAllMaintenance(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (list != null || list?.isNotEmpty == true) {
      if (_paginationControl.currentPage == 1) {
        _listMaintenance = list;
      } else {
        _listMaintenance?.addAll(list!);
      }
      _paginationControl.currentPage += 1;
    }
  }

  void terapkanFilter({
    required int selectedHandledBy,
    required int selectedSort,
  }) {
    _selectedHandledByOption = selectedHandledBy;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _handledByOptions.length; i++) {
      if (i == selectedHandledBy) {
        _handledByOptions[i].isSelected = true;
        continue;
      }
      _handledByOptions[i].isSelected = false;
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
