import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailCustomerViewModel extends BaseViewModel {
  DetailCustomerViewModel({
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

  Future<void> requestGetDetailCustomer() async {
    setBusy(true);
    resetErrorMsg();

    final response = await _apiService.getDetailCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
    );

    if (response.isRight) {
      _customerData = response.right;
      notifyListeners();
      setBusy(false);
      return;
    }

    _errorMsg = response.left.message;

    setBusy(false);
  }
}
