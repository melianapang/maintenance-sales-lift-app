import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/download_files_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ExportDataCustomerViewModel extends BaseViewModel {
  ExportDataCustomerViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  String? _exportedFileName;

  @override
  Future<void> initModel() async {}

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }

  Future<void> requestExportData() async {
    setBusy(true);
    String filePath = await _apiService.requestExportCustomerData();
    await _exportData(
      filePath: filePath,
    );
    setBusy(false);
  }

  Future<void> _exportData({
    required String filePath,
  }) async {
    _exportedFileName = await DownloadDataUtils.downloadData(
      prefixString: "customer_data",
      filePath: filePath,
    );
  }

  Future<void> openExportedData() async {
    if (_exportedFileName == null) return;
    await DownloadDataUtils.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );
  }
}
