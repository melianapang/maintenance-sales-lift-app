import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailUnitCustomerViewModel extends BaseViewModel {
  DetailUnitCustomerViewModel({
    UnitData? unitData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _unitData = unitData;

  final ApiService _apiService;

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

  UnitData? _unitData;
  UnitData? get unitData => _unitData;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<void> refreshPage() async {
    setBusy(true);
    await requestGetDetailUnit();
    setBusy(false);
  }

  Future<void> requestGetDetailUnit() async {
    final response = await _apiService.requestDetailUnit(
      unitId: int.parse(_unitData?.unitId ?? "0"),
    );

    if (response.isRight) {
      _unitData = response.right;
      notifyListeners();
    }
  }

  Future<bool> requestDeleteUnit() async {
    final response = await _apiService.requestDeleteUnit(
      unitId: int.parse(unitData?.unitId ?? "0"),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
