import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/download_files_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailCustomerViewModel extends BaseViewModel {
  DetailCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  //belom bener, harusnya dari customerData lgsg
  final List<String> _urlDocuments = [];
  List<String> get urlDocuments => _urlDocuments;

  //region extended fab
  SpeedDialDirection _speedDialDirection = SpeedDialDirection.up;
  SpeedDialDirection get selectedTahapKonfirmasiOption => _speedDialDirection;

  bool _isDialChildrenVisible = false;
  bool get isDialChildrenVisible => _isDialChildrenVisible;
  //endregion

  //region download berkas
  String? _exportedFileName;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  Future<bool> checkPermissions() async {
    return await PermissionUtils.requestPermission(
      Permission.manageExternalStorage,
    );
  }

  void setDialChildrenVisible() {
    _isDialChildrenVisible = !isDialChildrenVisible;
  }

  Future<void> downloadData({
    required int index,
  }) async {
    setBusy(true);
    _exportedFileName = await DownloadDataUtils.downloadData(
      prefixString: "maintenance_data",
      filePath: customerData?.documents[index].filePath ?? "",
    );
    setBusy(false);
  }

  Future<void> openDownloadedData() async {
    if (_exportedFileName == null) return;
    await DownloadDataUtils.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );
  }

  Future<void> requestGetDetailCustomer() async {
    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      notifyListeners();
    }
  }
}
