import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/download_files_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';

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

  final CustomerData? _customerData;
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

  @override
  Future<void> initModel() async {}

  Future<bool> checkPermissions() async {
    return await PermissionUtils.requestPermission(
      Permission.manageExternalStorage,
    );
  }

  StatusCardType get customerStatusCardType {
    switch (_customerData?.status ?? "") {
      case "0":
        return StatusCardType.Normal;
      case "1":
        return StatusCardType.Confirmed;
      case "2":
        return StatusCardType.Canceled;
      default:
        return StatusCardType.Normal;
    }
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
}
