import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListLogViewModel extends BaseViewModel {
  ListLogViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<LogData>? _listLogData;
  List<LogData>? get listLogData => _listLogData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _listLogData = await _apiService.requestGetAllLog();
    print("logDataa keys: ${_listLogData?[0].contentsOld.values}");
    print("logDataa entries: ${_listLogData?[0].contentsNew.values}");
    setBusy(false);
  }
}
