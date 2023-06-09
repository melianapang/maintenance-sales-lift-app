import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_type_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailNonProjectCustomerViewModel extends BaseViewModel {
  DetailNonProjectCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;

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

  //(dynamic values from API)
  String selectedCustomerNeedFilterName = "";
  List<CustomerNeedData>? _listCustomerNeed;
  List<CustomerNeedData>? get listCustomerNeed => _listCustomerNeed;

  String selectedCustomerTypeFilterName = "";
  List<CustomerTypeData>? _listCustomerType;
  List<CustomerTypeData>? get listCustomerType => _listCustomerType;
  // End of Dropdown related

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetAllCustomerNeed();
    await requestGetAllCustomerType();
    handleDynamicData();
    setBusy(false);
  }

  void handleDynamicData() {
    selectedCustomerNeedFilterName = _listCustomerNeed
            ?.firstWhere(
              (element) => element.customerNeedId == customerData?.customerNeed,
            )
            .customerNeedName ??
        "";
    selectedCustomerTypeFilterName = _listCustomerType
            ?.firstWhere(
              (element) => element.customerTypeId == customerData?.customerType,
            )
            .customerTypeName ??
        "";
  }

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

  Future<void> refreshPage() async {
    _errorMsg = null;

    await requestGetAllCustomerNeed();
    await requestGetAllCustomerType();
    await requestGetDetailCustomer();
  }

  Future<void> requestGetDetailCustomer() async {
    setBusy(true);
    resetErrorMsg();

    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      handleDynamicData();
      notifyListeners();
      setBusy(false);
      return;
    }

    _errorMsg = response.left.message;

    setBusy(false);
  }

  Future<void> requestGetAllCustomerNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        _listCustomerNeed = response.right.result;
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestGetAllCustomerType() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerTypeWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        _listCustomerType = response.right.result;
      }
      return;
    }

    _errorMsg = response.left.message;
  }
}
