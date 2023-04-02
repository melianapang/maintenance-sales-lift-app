import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListProjectViewModel extends BaseViewModel {
  ListProjectViewModel();

  List<String> _listProject = [];
  List<String> get listProject => _listProject;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  @override
  Future<void> initModel() async {
    setBusy(true);
    if (_listProject.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
