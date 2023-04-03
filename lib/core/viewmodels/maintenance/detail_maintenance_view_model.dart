import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_history_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailMaintenanceViewModel extends BaseViewModel {
  DetailMaintenanceViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
    required NavigationService navigationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _navigationService = navigationService,
        _maintenanceData = maintenanceData;

  final ApiService _apiService;
  final NavigationService _navigationService;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  List<MaintenanceData>? _historyData;
  List<MaintenanceData>? get historyData => _historyData;

  List<TimelineData> _timelineData = [];
  List<TimelineData> get timelineData => _timelineData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetHistoryMaintenance();
    setBusy(false);
  }

  Future<void> requestGetHistoryMaintenance() async {
    _historyData = await _apiService.requestGetAllHistoryMaintenance(
      _maintenanceData?.unitId ?? "",
    );
    if (_historyData != null) _mappingToTimelineData();
  }

  void _mappingToTimelineData() {
    if (_historyData == null) return;

    for (var data in _historyData!) {
      _timelineData.add(
        TimelineData(
          date: data.endMaintenance,
          note: data.maintenanceResult,
          onTap: () {
            _navigationService.navigateTo(
              Routes.detailHistoryMaintenance,
              arguments: DetailHistoryMaintenanceViewParam(
                maintenanceData: _maintenanceData,
              ),
            );
          },
        ),
      );
    }
    notifyListeners();
  }
}
