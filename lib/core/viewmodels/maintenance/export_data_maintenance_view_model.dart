import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ExportDataMaintenanceViewModel extends BaseViewModel {
  ExportDataMaintenanceViewModel({
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

  //region pilih proyek
  List<ProjectData>? _listProject;
  List<ProjectData>? get listProject => _listProject;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  ProjectData? _selectedProject;
  ProjectData? get selectedProject => _selectedProject;

  String? _exportedFileName;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _isAllowedToOpenPage =
        await PermissionUtils.requestPermissions(listPermission: [
      Permission.storage,
    ]);
    notifyListeners();

    paginationControl.currentPage = 1;

    await requestGetAllProjects();

    setBusy(false);
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProject = _listProject?[selectedIndex];
    notifyListeners();
  }

  Future<void> requestGetAllProjects() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    _errorMsg = null;

    final response = await _apiService.getAllProjects(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listProject = response.right.result;
        } else {
          _listProject?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        _isShowNoDataFoundPage =
            _listProject?.isEmpty == true || _listProject == null;

        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestExportData() async {
    _exportedFileName = await _downloadService.downloadData(
      prefixString: "maintenance_data",
      filePath:
          "${EnvConstants.baseURL}/api/0/Maintenance/create_maintenance_excel",
    );
  }

  Future<void> openExportedData() async {
    if (_exportedFileName == null) return;
    await _downloadService.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );
  }
}
