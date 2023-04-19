import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
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

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetDetailReminder();
    setBusy(false);
  }

  Future<void> requestGetDetailReminder() async {
    if (param?.reminderId == null || param?.reminderId.isEmpty == true) return;

    final response = await _apiService.requestDetailReminder(
      reminderId: int.parse(param?.reminderId ?? "0"),
    );

    if (response.isRight) {
      _reminderData = response.right;
      await requestDetailCustomer();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestDetailCustomer() async {
    if (param?.reminderId == null || param?.reminderId.isEmpty == true) return;
    if (_reminderData?.customerId == null) return;

    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_reminderData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      return;
    }

    _errorMsg = response.left.message;
  }
}
