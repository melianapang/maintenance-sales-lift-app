import 'package:dio/dio.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_history_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';
import 'package:intl/intl.dart';

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

  bool _isAllowedToDeleteMaintenance = false;
  bool get isAllowedToDeleteMaintenance => _isAllowedToDeleteMaintenance;

  bool _isAllowedToChangeMaintenanceDate = false;
  bool get isAllowedToChangeMaintenanceDate =>
      _isAllowedToChangeMaintenanceDate;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  StatusCardType _statusCardType = StatusCardType.Normal;
  StatusCardType get statusCardType => _statusCardType;

  List<HistoryMaintenanceData>? _historyData;
  List<HistoryMaintenanceData>? get historyData => _historyData;

  List<TimelineData> _timelineData = [];
  List<TimelineData> get timelineData => _timelineData;

  //region extended fab
  SpeedDialDirection _speedDialDirection = SpeedDialDirection.up;
  SpeedDialDirection get selectedTahapKonfirmasiOption => _speedDialDirection;

  bool _isDialChildrenVisible = false;
  bool get isDialChildrenVisible => _isDialChildrenVisible;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetHistoryMaintenance();
    await isUserAllowedToEditMaintenance();
    setStatusCard();
    setBusy(false);
  }

  void setDialChildrenVisible() {
    _isDialChildrenVisible = !isDialChildrenVisible;
  }

  void setStatusCard() {
    MaintenanceStatus status = mappingStringtoMaintenanceStatus(
        _historyData?.first.maintenanceResult ?? "0");
    switch (status) {
      case MaintenanceStatus.NOT_MAINTENANCED:
        _statusCardType = StatusCardType.Pending;
        break;
      case MaintenanceStatus.FAILED:
      case MaintenanceStatus.DELETED:
        _statusCardType = StatusCardType.Canceled;
        break;
      case MaintenanceStatus.SUCCESS:
      default:
        _statusCardType = StatusCardType.Confirmed;
    }
  }

  Future<void> isUserAllowedToEditMaintenance() async {
    Role role = await _authenticationService.getUserRole();
    bool isAfterToday = DateTimeUtils.isDateStringAfterToday(
        _maintenanceData?.scheduleDate ?? "");
    bool isNotMaintenanced = mappingStringtoMaintenanceStatus(
            _maintenanceData?.maintenanceResult ?? "0") ==
        MaintenanceStatus.NOT_MAINTENANCED;

    _isAllowedToDeleteMaintenance =
        role == Role.SuperAdmin && isNotMaintenanced && isAfterToday;

    _isAllowedToChangeMaintenanceDate =
        (role == Role.Admin || role == Role.SuperAdmin) &&
            isNotMaintenanced &&
            isAfterToday;
  }

  Future<void> requestGetHistoryMaintenance() async {
    final response = await _apiService.requestGetHistoryMaintenance(
      _maintenanceData?.unitId ?? "",
    );

    if (response.isRight) {
      _historyData = response.right;
      _mappingToTimelineData();
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestGetDetailMaintenance() async {
    final response = await _apiService.requestMaintenaceDetail(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
    );

    if (response.isRight) {
      _maintenanceData = response.right;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  void _mappingToTimelineData() {
    if (_historyData == null || _historyData?.isEmpty == true) return;

    for (int i = 0; i < (_historyData?.length ?? 0); i++) {
      _timelineData.add(
        TimelineData(
          date: DateTimeUtils.convertStringToOtherStringDateFormat(
            date: _historyData?[i].scheduleDate ??
                DateTimeUtils.convertDateToString(
                  date: DateTime.now(),
                  formatter: DateFormat(
                    DateTimeUtils.DATE_FORMAT_2,
                  ),
                ),
            formattedString: DateTimeUtils.DATE_FORMAT_2,
          ),
          note: mappingStringNumerictoString(
              _historyData?[i].maintenanceResult ?? "0"),
          onTap: () {
            _navigationService.navigateTo(
              Routes.detailHistoryMaintenance,
              arguments: DetailHistoryMaintenanceViewParam(
                historyData: _historyData?[i],
              ),
            );
          },
        ),
      );
    }
    notifyListeners();
  }
}
