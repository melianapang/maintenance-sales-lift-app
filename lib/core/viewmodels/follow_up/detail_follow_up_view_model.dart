import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_history_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailFollowUpViewModel extends BaseViewModel {
  DetailFollowUpViewModel({
    String? projectId,
    String? projectName,
    String? customerId,
    String? customerName,
    String? companyName,
    String? followUpId,
    String? nextFollowUpDate,
    String? salesOwnedId,
    required DioService dioService,
    required NavigationService navigationService,
    required AuthenticationService authenticationService,
  })  : _projectId = projectId,
        _projectName = projectName,
        _companyName = companyName,
        _customerName = customerName,
        _customerId = customerId,
        _followUpId = followUpId,
        _salesOwnedId = salesOwnedId,
        _nextFollowUpDate = nextFollowUpDate,
        _navigationService = navigationService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService;

  final ApiService _apiService;
  final NavigationService _navigationService;
  AuthenticationService _authenticationService;

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

  String? _projectId;
  String? get projectId => _projectId;

  String? _projectName;
  String? get projectName => _projectName;

  String? _customerId;
  String? get customerId => _customerId;

  String? _customerName;
  String? get customerName => _customerName;

  String? _companyName;
  String? get companyName => _companyName;

  String? _followUpId;
  String? get followUpId => _followUpId;

  String? _salesOwnedId;
  String? get salesOwnedId => _salesOwnedId;

  String? _nextFollowUpDate;
  String? get nextFollowUpDate => _nextFollowUpDate;

  List<HistoryFollowUpData> _historyData = [];
  List<HistoryFollowUpData> get historyData => _historyData;

  List<TimelineData> _timelineData = [];
  List<TimelineData> get timelineData => _timelineData;

  StatusCardType _statusCardType = StatusCardType.InProgress;
  StatusCardType get statusCardType => _statusCardType;

  bool _isAllowedToEditConfidentialInfo = false;
  bool get isAllowedToEditConfidentialInfo => _isAllowedToEditConfidentialInfo;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await _setIsAllowedToSeeProjectInfo();
    await requestGetHistoryFollowUp();
    setBusy(false);
  }

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  void _setStatusCard() {
    FollowUpStatus status = FollowUpStatus.values[int.parse(
      _historyData.first.followUpResult,
    )];

    switch (status) {
      case FollowUpStatus.Loss:
        _statusCardType = StatusCardType.Loss;
        break;
      case FollowUpStatus.Win:
        _statusCardType = StatusCardType.Win;
        break;
      case FollowUpStatus.Hot:
        _statusCardType = StatusCardType.Hot;
        break;
      case FollowUpStatus.In_Progress:
      default:
        _statusCardType = StatusCardType.InProgress;
    }
  }

  Future<void> _setIsAllowedToSeeProjectInfo() async {
    Role userRole = await _authenticationService.getUserRole();
    String userId = await _authenticationService.getUserId();

    _isAllowedToEditConfidentialInfo = userRole == Role.SuperAdmin ||
        userRole == Role.Admin ||
        (userRole == Role.Sales && userId == salesOwnedId);
  }

  void _mappingToTimelineData() {
    if (_historyData.isEmpty) return;

    _timelineData = [];
    for (int i = 0; i < _historyData.length; i++) {
      _timelineData.add(
        TimelineData(
          date: DateTimeUtils.convertStringToOtherStringDateFormat(
            date: _historyData[i].scheduleDate,
            formattedString: DateTimeUtils.DATE_FORMAT_2,
          ),
          note: mappingFollowUpStringNumericToString(
            _historyData[i].followUpResult,
          ),
          onTap: () {
            _navigationService.navigateTo(
              Routes.detailHistoryFollowUp,
              arguments: DetailHistoryFollowUpViewParam(
                historyData: _historyData[i],
              ),
            );
          },
        ),
      );
    }
    notifyListeners();
  }

  Future<void> requestGetHistoryFollowUp() async {
    final response = await _apiService.requestGetHistoryFollowUp(
      projectId: _projectId ?? "0",
    );

    if (response.isRight) {
      if (response.right.isEmpty) return;

      _historyData = response.right;
      _mappingToTimelineData();
      _setStatusCard();
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> _getNextFollowUpDate() async {
    final response = await _apiService.requestGetNextFollowUpDateByProjectId(
      projectId: int.parse(projectId ?? "0"),
    );

    if (response.isRight) {
      _nextFollowUpDate = response.right.scheduleDate;
      _followUpId = response.right.followUpId;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);
    _errorMsg = null;
    await _getNextFollowUpDate();
    await requestGetHistoryFollowUp();
    setBusy(false);
  }
}
