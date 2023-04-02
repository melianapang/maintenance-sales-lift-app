import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListUserViewModel extends BaseViewModel {
  ListUserViewModel();

  List<String> _listUser = [];
  List<String> get listUser => _listUser;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  @override
  Future<void> initModel() async {
    setBusy(true);
    if (_listUser.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
