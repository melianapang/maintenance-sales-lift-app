import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditUnitCustomerViewModel extends BaseViewModel {
  EditUnitCustomerViewModel({
    UnitData? unitData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _unitData = unitData;

  final ApiService _apiService;

  UnitData? _unitData;
  UnitData? get unitData => _unitData;

  final namaUnitController = TextEditingController();
  final lokasiUnitController = TextEditingController();

  bool _isNamaValid = true;
  bool get isNamaValid => _isNamaValid;

  bool _isLocationValid = true;
  bool get isLocationValid => _isLocationValid;

  //region pilih proyek
  //dummy pake customerData, harus ganti nanti
  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  CustomerData? _selectedProyek;
  CustomerData? get selectedProyek => _selectedProyek;
  //endregion

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllProjects();
    if (_listCustomer?.isEmpty == true || _listCustomer == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }

  void onChangedNama(String value) {
    _isNamaValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedLocation(String value) {
    _isLocationValid = value.isNotEmpty;
    notifyListeners();
  }

  Future<void> requestGetAllProjects() async {
    // List<CustomerData>? list = await _apiService.getAllCustomer(
    //   _paginationControl.currentPage,
    //   _paginationControl.pageSize,
    // );

    // if (list != null || list?.isNotEmpty == true) {
    //   if (_paginationControl.currentPage == 1) {
    //     _listCustomer = list;
    //   } else {
    //     _listCustomer?.addAll(list!);
    //   }
    //   _paginationControl.currentPage += 1;
    //   notifyListeners();
    // }
  }

  void setSelectedProyek({
    required int selectedIndex,
  }) {
    _selectedProyek = _listCustomer?[selectedIndex];
    notifyListeners();
  }

  bool isValid() {
    _isNamaValid = namaUnitController.text.isNotEmpty;
    _isLocationValid = lokasiUnitController.text.isNotEmpty;
    notifyListeners();

    return _isNamaValid && _isLocationValid;
  }

  Future<bool> requestUpdateCustomer() async {
    setBusy(true);
    // final response = await _apiService.requestUpdateCustomer(
    //   customerId: _customer?.customerId ?? 0,
    //   nama: _customer?.customerName ?? "",
    //   customerNumber: _customer?.customerNumber ?? "",
    //   customerNeed: _customer?.customerNeed ?? "",
    //   email: _customer?.email ?? "",
    //   phoneNumber: _customer?.phoneNumber ?? "",
    //   city: _customer?.city ?? "",
    //   note: _customer?.note ?? "",
    //   companyName: _customer?.companyName ?? "",
    //   dataSource: _selectedSumberDataOption,
    //   customerType: _selectedTipePelangganOption,
    // );
    setBusy(false);
    // return response != null;
    return true;
  }
}
