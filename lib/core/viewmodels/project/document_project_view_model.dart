import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
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

  List<DocumentData>? _listDocument;
  List<DocumentData>? get listDocument => _listDocument;

  //belom bener, harusnya dari customerData lgsg
  final List<String> _urlDocuments = [];
  List<String> get urlDocuments => _urlDocuments;

  //region download berkas
  String? _exportedFileName;
  //endregion

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _paginationControl.currentPage = 1;
    _listDocument = _projectData?.documents;
    setBusy(false);
  }

  Future<bool> checkPermissions() async {
    return await PermissionUtils.requestPermission(
      Permission.storage,
    );
  }

  void resetErrorMsg() {
    _errorMsg = null;
    _paginationControl.currentPage = 1;
  }

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<void> downloadData({
    required int index,
  }) async {
    resetErrorMsg();

    String filePath = _listDocument?[index].filePath ?? "";
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

  Future<void> requestGetAllDocuments() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestGetAllDocuments(
      projectId: int.parse(_projectData?.projectId ?? "0"),
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listDocument = response.right.result;
        } else {
          _listDocument?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }
}
