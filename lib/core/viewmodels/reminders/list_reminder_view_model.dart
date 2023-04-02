import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListReminderViewModel extends BaseViewModel {
  ListReminderViewModel();

  List<String> _listReminder = [];
  List<String> get listReminder => _listReminder;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  @override
  Future<void> initModel() async {
    setBusy(true);
    if (_listReminder.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
