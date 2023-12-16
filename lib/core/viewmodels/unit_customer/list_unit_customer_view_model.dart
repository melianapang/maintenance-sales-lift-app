import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';

class ListUnitCustomerViewModel extends BaseViewModel {
  ListUnitCustomerViewModel({
    ProjectData? projectData,
    CustomerData? customerData,
    ListUnitCustomerSourcePage? sourcePage,
    required DioService dioService,
  })  : _customerData = customerData,
        _projectData = projectData,
        _sourcePage = sourcePage,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  ListUnitCustomerSourcePage? _sourcePage;
  ListUnitCustomerSourcePage? get sourcePage => _sourcePage;

  //will only be used if user entry this page from detail project page
  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  //will only be used if user entry this page from detail customer pages
  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  List<UnitData>? _listUnit;
  List<UnitData>? get listUnit => _listUnit;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllUnit();

    _isShowNoDataFoundPage = _listUnit?.isEmpty == true || _listUnit == null;
    notifyListeners();

    setBusy(false);
  }

  void search(String text) {
    if (busy || _listUnit?.isEmpty == true || _listUnit == null) return;
    setBusy(true);

    setBusy(false);
  }

  Future<void> requestGetAllUnit() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    int customerOrProjectId;
    String type;
    if (_sourcePage == ListUnitCustomerSourcePage.DetailProject) {
      customerOrProjectId = int.parse(_projectData?.projectId ?? "0");
      type = MaintenanceDataType.project.localeKey;
    } else {
      customerOrProjectId = int.parse(_customerData?.customerId ?? "0");
      type = MaintenanceDataType.customer.localeKey;
    }

    final response = await _apiService.getAllUnitByCustomer(
      customerId: customerOrProjectId,
      type: type,
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (_paginationControl.currentPage == 1) {
        _listUnit = response.right.result;
      } else {
        _listUnit?.addAll(response.right.result);
      }

      if (response.right.result.isNotEmpty) {
        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    resetPage();
    await requestGetAllUnit();
    _isShowNoDataFoundPage = _listUnit?.isEmpty == true || _listUnit == null;
    notifyListeners();

    setBusy(false);
  }

  void resetPage() {
    _listUnit = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }
}
