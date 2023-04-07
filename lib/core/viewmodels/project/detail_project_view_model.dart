import 'package:rejo_jaya_sakti_apps/core/models/project/project_data.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';

class DetailProjectViewModel extends BaseViewModel {
  DetailProjectViewModel({
    required ProjectData? projectData,
    required AuthenticationService authenticationService,
  })  : _projectData = projectData,
        _authenticationService = authenticationService;

  AuthenticationService _authenticationService;
  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  bool _isAllowedToDeleteData = false;
  bool get isAllowedToDeleteData => _isAllowedToDeleteData;

  List<PicData> _listPic = [];
  List<PicData> get listPic => _listPic;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _checkIsAllowedToDeleteData();
    setBusy(false);
  }

  void _checkIsAllowedToDeleteData() {
    _isAllowedToDeleteData =
        _authenticationService.getUserRole() == Role.SuperAdmin;
  }
}
