import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListFollowUpViewModel extends BaseViewModel {
  ListFollowUpViewModel();

  List<String> _listFollowUp = [];
  List<String> get listFollowUp => _listFollowUp;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  @override
  Future<void> initModel() async {
    setBusy(true);
    if (_listFollowUp.isEmpty || _listFollowUp == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
