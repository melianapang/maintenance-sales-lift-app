import 'dart:math';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailCustomerViewModel extends BaseViewModel {
  DetailCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
    required DownloadService downloadService,
  })  : _downloadService = downloadService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;
  final DownloadService _downloadService;

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

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

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<bool> checkPermissions() async {
    return await PermissionUtils.requestPermission(
      Permission.storage,
    );
  }

  void setDialChildrenVisible() {
    _isDialChildrenVisible = !isDialChildrenVisible;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<void> downloadData({
    required int index,
  }) async {
    setBusy(true);

    resetErrorMsg();

    String filePath = customerData?.documents[index].filePath ?? "";
    final fileName = filePath.split('/').last.split('?').first;
    _exportedFileName = await _downloadService.setFilePath(fileName);

    if (_downloadService.isFileExist(filePath: _exportedFileName ?? "")) {
      openDownloadedData();
      setBusy(false);
      return;
    }

    bool result = await _downloadService.downloadFile(
      filePath,
      _exportedFileName ?? "",
    );
    if (result) openDownloadedData();

    setBusy(false);
  }

  Future<void> openDownloadedData() async {
    if (_exportedFileName == null) {
      _errorMsg = "Berkas yang diunduh tidak ditemukan";
      return;
    }

    OpenResult result = await _downloadService.openPdfData(
      fileName: _exportedFileName ?? "",
      type: "application/pdf",
    );

    switch (result.type) {
      case ResultType.done:
        break;
      case ResultType.fileNotFound:
        _errorMsg = "Tidak menemukan berkas yang diinginkan.";
        break;
      case ResultType.noAppToOpen:
        _errorMsg =
            "Tidak ada aplikasi yang mendukung untuk membuka jenis berkas ini.";
        break;
      case ResultType.error:
        _errorMsg = "Tidak dapat membuka berkas.";
        break;
      case ResultType.permissionDenied:
        _errorMsg = "Tidak ada ijin mengakses untuk data.";
        break;
    }
  }

  Future<void> requestGetDetailCustomer() async {
    resetErrorMsg();

    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      notifyListeners();
    }

    _errorMsg = response.left.message;
  }
}
