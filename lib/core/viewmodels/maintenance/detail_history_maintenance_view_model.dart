import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailHistoryMaintenanceViewModel extends BaseViewModel {
  DetailHistoryMaintenanceViewModel({
    required MaintenanceData? maintenanceData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _maintenanceData = maintenanceData;

  final ApiService _apiService;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }
}
