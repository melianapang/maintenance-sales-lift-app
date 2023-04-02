import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailLogViewModel extends BaseViewModel {
  DetailLogViewModel({
    LogData? logData,
  }) : _logData = logData;

  LogData? _logData;
  LogData? get logData => _logData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }
}
