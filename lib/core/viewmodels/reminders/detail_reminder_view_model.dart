import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailReminderViewModel extends BaseViewModel {
  DetailReminderViewModel({
    ReminderData? reminderData,
  }) : _reminderData = reminderData;

  ReminderData? _reminderData;
  ReminderData? get reminderData => _reminderData;

  @override
  Future<void> initModel() async {}
}
