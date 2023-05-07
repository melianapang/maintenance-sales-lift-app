import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailProjectViewModel extends BaseViewModel {
  DetailProjectViewModel({
    required ProjectData? projectData,
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _projectData = projectData,
        _authenticationService = authenticationService;

  final ApiService _apiService;
  AuthenticationService _authenticationService;

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  bool _isAllowedToDeleteData = false;
  bool get isAllowedToDeleteData => _isAllowedToDeleteData;

  List<PICProject> _listPic = [];
  List<PICProject> get listPic => _listPic;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _listPic.addAll(projectData?.pics ?? []);
    await _checkIsAllowedToDeleteData();
    setBusy(false);
  }

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<void> _checkIsAllowedToDeleteData() async {
    _isAllowedToDeleteData =
        await _authenticationService.getUserRole() == Role.SuperAdmin;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<void> requestGetDetailProject() async {
    final response = await _apiService.requestDetailProject(
      projectId: int.parse(_projectData?.projectId ?? "0"),
    );

    if (response.isRight) {
      _projectData = response.right;
      notifyListeners();
    }
  }

  Future<bool> requestDeleteProject() async {
    final response = await _apiService.requestDeleteProject(
      projectId: int.parse(_projectData?.projectId ?? "0"),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> refreshPage() async {
    setBusy(true);
    resetErrorMsg();
    await requestGetDetailProject();
    notifyListeners();
    setBusy(false);
  }
}
