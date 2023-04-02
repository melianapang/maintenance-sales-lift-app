import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListApprovalViewModel extends BaseViewModel {
  ListApprovalViewModel();

  List<String> _listApproval = [];
  List<String> get listApproval => _listApproval;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  @override
  Future<void> initModel() async {
    setBusy(true);
    if (_listApproval.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
