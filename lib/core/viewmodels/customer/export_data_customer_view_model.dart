import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportDataCustomerViewModel extends BaseViewModel {
  ExportDataCustomerViewModel({
    required DioService dioService,
    required DownloadService downloadService,
  })  : _downloadService = downloadService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;
  final DownloadService _downloadService;

  bool _isAllowedToOpenPage = false;
  bool get isAllowedToOpenPage => _isAllowedToOpenPage;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  String? _exportedFileName;

  @override
  Future<void> initModel() async {
    _isAllowedToOpenPage =
        await PermissionUtils.requestPermissions(listPermission: [
      Permission.storage,
    ]);
    notifyListeners();
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }

  Future<void> requestExportData() async {
    setBusy(true);
    //_apiService.requestExportCustomerData();
    _exportedFileName = await _downloadService.downloadData(
      prefixString: "customer_data",
      filePath: "${EnvConstants.baseURL}/api/0/Customer/create_customer_excel",
    );
    setBusy(false);
  }

  Future<void> openExportedData() async {
    if (_exportedFileName == null) return;
    await _downloadService.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );
  }
}
