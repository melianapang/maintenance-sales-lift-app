import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_data.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/download_data_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ExportDataMaintenanceViewModel extends BaseViewModel {
  ExportDataMaintenanceViewModel({
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

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllProjects();
    if (_listProject?.isEmpty == true || _listProject == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

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
    List<ProjectData>? list = await _apiService.getAllProjects(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (list != null || list?.isNotEmpty == true) {
      if (_paginationControl.currentPage == 1) {
        _listProject = list;
      } else {
        _listProject?.addAll(list!);
      }
      _paginationControl.currentPage += 1;
      notifyListeners();
    }
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
    _exportedFileName = await ExportDataUtils.downloadData(
      prefixString: "maintenance_data",
      filePath: filePath,
    );
  }

  Future<void> openExportedData() async {
    if (_exportedFileName == null) return;
    await ExportDataUtils.openDownloadedData(
      fileName: _exportedFileName ?? "",
    );
  }
}
