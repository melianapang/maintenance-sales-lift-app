import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_history_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailMaintenanceViewModel extends BaseViewModel {
  DetailMaintenanceViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
    required NavigationService navigationService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _navigationService = navigationService,
        _authenticationService = authenticationService,
        _maintenanceData = maintenanceData;

  final ApiService _apiService;
  final NavigationService _navigationService;
  final AuthenticationService _authenticationService;

  bool _isAllowedToDeleteNextMaintenance = false;
  bool get isAllowedToDeleteNextMaintenance =>
      _isAllowedToDeleteNextMaintenance;

  bool _isAllowedToChangeNextMaintenanceDate = false;
  bool get isAllowedToChangeNextMaintenanceDate =>
      _isAllowedToChangeNextMaintenanceDate;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  StatusCardType _statusCardType = StatusCardType.Normal;
  StatusCardType get statusCardType => _statusCardType;

  List<MaintenanceData>? _historyData;
  List<MaintenanceData>? get historyData => _historyData;

  List<TimelineData> _timelineData = [];
  List<TimelineData> get timelineData => _timelineData;

  //region extended fab
  SpeedDialDirection _speedDialDirection = SpeedDialDirection.up;
  SpeedDialDirection get selectedTahapKonfirmasiOption => _speedDialDirection;

  bool _isDialChildrenVisible = false;
  bool get isDialChildrenVisible => _isDialChildrenVisible;
  //endregion

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetHistoryMaintenance();
    await isUserAllowedToDeleteNextMaintenance();
    await isUserAllowedToChangeNextMaintenanceDate();
    setStatusCard();
    setBusy(false);
  }

  void setDialChildrenVisible() {
    _isDialChildrenVisible = !isDialChildrenVisible;
  }

  void setStatusCard() {
    MaintenanceStatus status = mappingStringtoMaintenanceStatus(
        _maintenanceData?.maintenanceResult ?? "0");
    switch (status) {
      case MaintenanceStatus.NOT_MAINTENANCED:
        _statusCardType = StatusCardType.Pending;
        break;
      case MaintenanceStatus.FAILED:
        _statusCardType = StatusCardType.Canceled;
        break;
      case MaintenanceStatus.SUCCESS:
        _statusCardType = StatusCardType.Normal;
        break;
      case MaintenanceStatus.DELETED:
        _statusCardType = StatusCardType.Canceled;
        break;
      default:
        _statusCardType = StatusCardType.Normal;
    }
  }

  Future<void> isUserAllowedToDeleteNextMaintenance() async {
    Role role = await _authenticationService.getUserRole();
    bool isNotMaintenanced = mappingStringtoMaintenanceStatus(
            _maintenanceData?.maintenanceResult ?? "0") ==
        MaintenanceStatus.NOT_MAINTENANCED;
    _isAllowedToDeleteNextMaintenance =
        role == Role.SuperAdmin && isNotMaintenanced;
  }

  Future<void> isUserAllowedToChangeNextMaintenanceDate() async {
    Role role = await _authenticationService.getUserRole();
    bool isNotMaintenanced = mappingStringtoMaintenanceStatus(
            _maintenanceData?.maintenanceResult ?? "0") ==
        MaintenanceStatus.NOT_MAINTENANCED;
    _isAllowedToChangeNextMaintenanceDate =
        (role == Role.Admin || role == Role.SuperAdmin) && isNotMaintenanced;
  }

  Future<void> requestGetHistoryMaintenance() async {
    // _historyData = await _apiService.requestGetHistoryMaintenance(
    //   _maintenanceData?.unitId ?? "",
    // );
    // if (_historyData != null) _mappingToTimelineData();
  }

  void _mappingToTimelineData() {
    if (_historyData == null) return;

    for (var data in _historyData!) {
      _timelineData.add(
        TimelineData(
          date: data.scheduleDate,
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
