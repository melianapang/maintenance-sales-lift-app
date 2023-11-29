import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';

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

  StatusCardType _statusCardType = StatusCardType.Pending;
  StatusCardType get statusCardType => _statusCardType;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  //(dynamic values from API)
  String _selectedKeperluanProyekFilterName = "";
  String get selectedKeperluanProyekFilterName =>
      _selectedKeperluanProyekFilterName;

  List<CustomerNeedData>? _listKeperluanProyek;
  List<CustomerNeedData>? get listKeperluanProyek => _listKeperluanProyek;

  bool _isAllowedToDeleteData = false;
  bool get isAllowedToDeleteData => _isAllowedToDeleteData;

  bool _isAllowedToSeeConfidentialInfo = false;
  bool get isAllowedToSeeConfidentialInfo => _isAllowedToSeeConfidentialInfo;

  List<PICProject> _listPic = [];
  List<PICProject> get listPic => _listPic;

  //region extended fab
  SpeedDialDirection _speedDialDirection = SpeedDialDirection.up;
  SpeedDialDirection get selectedTahapKonfirmasiOption => _speedDialDirection;

  bool _isDialChildrenVisible = false;
  bool get isDialChildrenVisible => _isDialChildrenVisible;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _listPic.addAll(projectData?.pics ?? []);
    await _setIsAllowedToSeeProjectInfo();
    await _checkIsAllowedToDeleteData();
    await _getCustomerDetail();

    await requestGetAllProjectNeed();
    _handleDynamicProjectNeedData();
    setStatusCard();
    setBusy(false);
  }

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<void> _checkIsAllowedToDeleteData() async {
    _isAllowedToDeleteData =
        await _authenticationService.getUserRole() == Role.SuperAdmin;
  }

  void setStatusCard() {
    if (_projectData == null) return;

    int status = int.parse(_projectData?.lastFollowUpResult ?? "-1");
    if (status == FollowUpStatus.Loss.index) {
      _statusCardType = StatusCardType.Loss;
    } else if (status == FollowUpStatus.Hot.index) {
      _statusCardType = StatusCardType.Hot;
    } else if (status == FollowUpStatus.Win.index) {
      _statusCardType = StatusCardType.Confirmed;
    } else {
      _statusCardType = StatusCardType.Pending;
    }
  }

  void setDialChildrenVisible() {
    _isDialChildrenVisible = !isDialChildrenVisible;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void _handleDynamicProjectNeedData() {
    _selectedKeperluanProyekFilterName = _listKeperluanProyek
            ?.firstWhere(
              (element) => element.customerNeedId == projectData?.projectNeed,
            )
            .customerNeedName ??
        "";
  }

  Future<void> requestGetAllProjectNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        _listKeperluanProyek = response.right.result;
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> _setIsAllowedToSeeProjectInfo() async {
    Role userRole = await _authenticationService.getUserRole();
    String userId = await _authenticationService.getUserId();

    _isAllowedToSeeConfidentialInfo = userRole == Role.SuperAdmin ||
        userRole == Role.Admin ||
        (userRole == Role.Sales && userId == _projectData?.salesOwnedId);
  }

  Future<void> requestGetDetailProject() async {
    final response = await _apiService.requestDetailProject(
      projectId: int.parse(_projectData?.projectId ?? "0"),
    );

    if (response.isRight) {
      _projectData = response.right;
      _listPic = response.right.pics;
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

  Future<void> _getCustomerDetail() async {
    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_projectData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);
    resetErrorMsg();
    await requestGetDetailProject();
    _handleDynamicProjectNeedData();
    setStatusCard();
    notifyListeners();
    setBusy(false);
  }
}
