import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailHistoryMaintenanceViewModel extends BaseViewModel {
  DetailHistoryMaintenanceViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }
}