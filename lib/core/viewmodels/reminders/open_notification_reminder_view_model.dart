import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/open_notification_reminder_view.dart';

class OpenNotificationReminderViewModel extends BaseViewModel {
  OpenNotificationReminderViewModel({
    OpenNotificationReminderViewParam? param,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _param = param;

  final ApiService _apiService;

  OpenNotificationReminderViewParam? _param;
  OpenNotificationReminderViewParam? get param => _param;

  ReminderData? _reminderData;
  ReminderData? get reminderData => _reminderData;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetDetailReminder();
    setBusy(false);
  }

  Future<void> requestGetDetailReminder() async {
    if (param?.reminderId == null || param?.reminderId.isEmpty == true) return;
    resetErrorMsg();

    final response = await _apiService.requestDetailReminder(
      reminderId: int.parse(param?.reminderId ?? "0"),
    );

    if (response.isRight) {
      _reminderData = response.right;
      if (_reminderData?.maintenanceId != null) {
        await requestDetailMaintenance();
      } else if (_reminderData?.projectId != null) {
        await requestDetailProject();
      }

      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestDetailProject() async {
    if (param?.reminderId == null || param?.reminderId.isEmpty == true) return;
    if (_reminderData?.projectId == null) return;
    resetErrorMsg();

    final response = await _apiService.requestDetailProject(
      projectId: int.parse(_reminderData?.projectId ?? "0"),
    );

    if (response.isRight) {
      _projectData = response.right;
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestDetailMaintenance() async {
    if (param?.reminderId == null || param?.reminderId.isEmpty == true) return;
    if (_reminderData?.maintenanceId == null) return;
    resetErrorMsg();

    final response = await _apiService.requestMaintenaceDetail(
      maintenanceId: int.parse(_reminderData?.maintenanceId ?? "0"),
    );

    if (response.isRight) {
      _maintenanceData = response.right;
      return;
    }

    _errorMsg = response.left.message;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }
}
