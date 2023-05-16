import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DocumentProjectViewModel extends BaseViewModel {
  DocumentProjectViewModel({
    ProjectData? projectData,
    required DioService dioService,
    required DownloadService downloadService,
  })  : _downloadService = downloadService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _projectData = projectData;

  final ApiService _apiService;
  final DownloadService _downloadService;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  //belom bener, harusnya dari customerData lgsg
  final List<String> _urlDocuments = [];
  List<String> get urlDocuments => _urlDocuments;

  //region download berkas
  String? _exportedFileName;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  Future<bool> checkPermissions() async {
    return await PermissionUtils.requestPermission(
      Permission.storage,
    );
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<void> downloadData({
    required int index,
  }) async {
    resetErrorMsg();

    String filePath = projectData?.documents?[index].filePath ?? "";
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
}
