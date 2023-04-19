import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailHistoryFollowUpViewModel extends BaseViewModel {
  DetailHistoryFollowUpViewModel({
    HistoryFollowUpData? historyData,
  }) : _historyData = historyData;

  HistoryFollowUpData? _historyData;
  HistoryFollowUpData? get historyData => _historyData;

  @override
  Future<void> initModel() async {}
}
