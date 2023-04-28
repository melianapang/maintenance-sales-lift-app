import 'package:open_filex/open_filex.dart';
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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

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
    _errorMsg = null;

    _exportedFileName = await _downloadService.downloadExportedData(
      prefixString: "customer_data",
      filePath: "${EnvConstants.baseURL}/api/0/Customer/create_customer_excel",
    );
    setBusy(false);
  }

  Future<bool> openExportedData() async {
    if (_exportedFileName == null) {
      _errorMsg = "Berkas yang diunduh tidak ditemukan";
      return false;
    }

    OpenResult result = await _downloadService.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );

    switch (result.type) {
      case ResultType.done:
        return true;
      case ResultType.fileNotFound:
        _errorMsg = "Tidak menemukan berkas yang diinginkan.";
        return false;
      case ResultType.noAppToOpen:
        _errorMsg =
            "Tidak ada aplikasi yang mendukung untuk membuka jenis berkas ini.";
        return false;
      case ResultType.error:
        _errorMsg = "Tidak dapat membuka berkas.";
        return false;
      case ResultType.permissionDenied:
        _errorMsg = "Tidak ada ijin mengakses untuk data.";
        return false;
    }
  }
}
