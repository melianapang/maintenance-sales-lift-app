import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_result.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_history_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailFollowUpViewModel extends BaseViewModel {
  DetailFollowUpViewModel({
    String? followUpId,
    String? customerId,
    String? customerName,
    String? companyName,
    required DioService dioService,
    required NavigationService navigationService,
  })  : _followUpId = followUpId,
        _customerId = customerId,
        _companyName = companyName,
        _customerName = customerName,
        _navigationService = navigationService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;
  final NavigationService _navigationService;

  String? _followUpId;
  String? get followUpId => _followUpId;

  String? _customerId;
  String? get customerId => _customerId;

  String? _customerName;
  String? get customerName => _customerName;

  String? _companyName;
  String? get companyName => _companyName;

  List<HistoryFollowUpData> _historyData = [];
  List<HistoryFollowUpData> get historyData => _historyData;

  List<TimelineData> _timelineData = [];
  List<TimelineData> get timelineData => _timelineData;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetHistoryFollowUp();
    setBusy(false);
  }

  Future<void> requestGetHistoryFollowUp() async {
    final response = await _apiService.requestGetHistoryFollowUp(
      customerId: _customerId ?? "0",
    );

    if (response.isRight) {
      _historyData = response.right;
      _mappingToTimelineData();
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  void _mappingToTimelineData() {
    if (_historyData.isEmpty) return;

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
}
