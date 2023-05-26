import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailReminderViewModel extends BaseViewModel {
  DetailReminderViewModel({
    required DioService dioService,
    ReminderData? reminderData,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _reminderData = reminderData;

  final ApiService _apiService;

  ReminderData? _reminderData;
  ReminderData? get reminderData => _reminderData;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  DetailFollowUpData? _followUpData;
  DetailFollowUpData? get followUpData => _followUpData;

  bool _isCanLinkToMaintenanceData = false;
  bool get isCanLinkToMaintenanceData => _isCanLinkToMaintenanceData;

  bool _isCanLinkToFollowUpData = false;
  bool get isCanLinkToFollowUpData => _isCanLinkToFollowUpData;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await setBottomButton();
    setBusy(false);
  }

  Future<void> setBottomButton() async {
    if (reminderData?.followUpId != null &&
        reminderData?.followUpId?.isNotEmpty == true) {
      await requestGetDetailFollowUp();
    }
    if (_isCanLinkToMaintenanceData = reminderData?.maintenanceId != null &&
        reminderData?.maintenanceId?.isNotEmpty == true) {
      await requestGetDetailMaintenance();
    }
  }

  Future<void> requestGetDetailMaintenance() async {
    final response = await _apiService.requestMaintenaceDetail(
      maintenanceId: int.parse(_reminderData?.maintenanceId ?? "0"),
    );

    _isCanLinkToMaintenanceData = response.isRight;
    if (response.isRight) {
      _maintenanceData = response.right;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestGetDetailFollowUp() async {
    final response = await _apiService.requestFollowUpDetail(
      followUpId: int.parse(_reminderData?.followUpId ?? "0"),
    );

    _isCanLinkToFollowUpData = response.isRight;
    if (response.isRight) {
      _followUpData = response.right;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }
}
