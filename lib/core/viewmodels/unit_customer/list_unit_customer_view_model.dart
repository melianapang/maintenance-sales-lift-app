import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListUnitCustomerViewModel extends BaseViewModel {
  ListUnitCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _customerData = customerData,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  List<UnitData>? _listUnit;
  List<UnitData>? get listUnit => _listUnit;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllUnit();
    if (_listUnit?.isEmpty == true || _listUnit == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }

  void search(String text) {
    if (busy || _listUnit?.isEmpty == true || _listUnit == null) return;
    setBusy(true);

    setBusy(false);
  }

  Future<void> requestGetAllUnit() async {
    final response = await _apiService.getAllUnitByCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listUnit = response.right;
        } else {
          _listUnit?.addAll(response.right!);
        }
        _paginationControl.currentPage += 1;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    _listUnit = [];
    paginationControl.currentPage = 1;

    await requestGetAllUnit();
    if (_listUnit?.isEmpty == true || _listUnit == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }
}
