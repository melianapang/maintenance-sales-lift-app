import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_customer_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListUnitCustomerViewModel extends BaseViewModel {
  ListUnitCustomerViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<UnitData>? _listUnit;
  List<UnitData>? get listUnit => _listUnit;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

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
    List<UnitData>? list = [
      UnitData(
        unitId: "1",
        unitName: "KA23492834",
        location: "Tower A",
      ),
    ];
    // await _apiService.getAllCustomer(
    //   _paginationControl.currentPage,
    //   _paginationControl.pageSize,
    // );

    if (list != null || list?.isNotEmpty == true) {
      if (_paginationControl.currentPage == 1) {
        _listUnit = list;
      } else {
        _listUnit?.addAll(list!);
      }
      _paginationControl.currentPage += 1;
      notifyListeners();
    }
  }
}
