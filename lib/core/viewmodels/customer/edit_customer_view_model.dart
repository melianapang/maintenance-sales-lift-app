import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_type_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditCustomerViewModel extends BaseViewModel {
  EditCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService,
        _customerData = customerData;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  bool _isSumberDataFieldVisible = true;
  bool get isSumberDataFieldVisible => _isSumberDataFieldVisible;

  // TextEditingController
  final sumberDataController = TextEditingController();
  final nomorPelangganController = TextEditingController();
  final namaPelangganController = TextEditingController();
  final namaPerusahaanController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  bool _isSumberDataValid = true;
  bool get isSumberDataValid => _isSumberDataValid;

  bool _isCustomerNameValid = true;
  bool get isCustomerNameValid => _isCustomerNameValid;

  bool _isCustomerNumberValid = true;
  bool get isCustomerNumberValid => _isCustomerNumberValid;

  bool _isCompanyNameValid = true;
  bool get isCompanyNameValid => _isCompanyNameValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  bool _isEmailValid = true;
  bool get isEmailValid => _isEmailValid;

  bool _isCityValid = true;
  bool get isCityValid => _isCityValid;
  // End of TextEditingController

  // Dropdown related (dynamic values from API)
  int _selectedCustomerNeedFilter = 0;
  int get selectedCustomerNeedFilter => _selectedCustomerNeedFilter;

  List<CustomerNeedData>? _listCustomerNeed;
  List<CustomerNeedData>? get listCustomerNeed => _listCustomerNeed;
  List<FilterOptionDynamic> customerNeedFilterOptions = [];

  int _selectedCustomerTypeFilter = 0;
  int get selectedCustomerTypeFilter => _selectedCustomerTypeFilter;

  List<CustomerTypeData>? _listCustomerType;
  List<CustomerTypeData>? get listCustomerType => _listCustomerType;
  List<FilterOptionDynamic> customerTypeFilterOptions = [];

  String get customerType {
    if (customerTypeFilterOptions.isEmpty) return "";

    final int index = customerTypeFilterOptions.indexWhere(
        (element) => int.parse(element.idFilter) == selectedCustomerTypeFilter);
    if (index > -1) {
      return customerTypeFilterOptions[index].title;
    }
    return "";
  }

  String get customerNeed {
    if (customerNeedFilterOptions.isEmpty) return "";

    final int index = customerNeedFilterOptions.indexWhere(
        (element) => int.parse(element.idFilter) == selectedCustomerNeedFilter);
    if (index > -1) {
      return customerNeedFilterOptions[index].title;
    }
    return "";
  }

  // End of Dropdown related

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  String? _msg = "";
  String? get msg => _msg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    await requestGetAllCustomerNeed();
    await requestGetAllCustomerType();

    if (_customerData != null) {
      _handleAvailableData();
      sumberDataController.text = _customerData?.dataSource ?? "";
      nomorPelangganController.text = _customerData?.customerNumber ?? "";
      namaPelangganController.text = _customerData?.customerName ?? "";
      namaPerusahaanController.text = _customerData?.companyName ?? "";
      phoneNumberController.text = _customerData?.phoneNumber ?? "";
      cityController.text = _customerData?.city ?? "";
      emailController.text = _customerData?.email ?? "";
      noteController.text = _customerData?.note ?? "";
    }

    _isSumberDataFieldVisibility();
    setBusy(false);
  }

  void _isSumberDataFieldVisibility() {
    _isSumberDataFieldVisible = customerData?.isLead == "1";
  }

  void _handleAvailableData() {
    _selectedCustomerTypeFilter = int.parse(_customerData?.customerType ?? "0");
    _selectedCustomerNeedFilter = int.parse(_customerData?.customerNeed ?? "0");

    setSelectedTipePelanggan(
      selectedMenu: _selectedCustomerTypeFilter,
    );
    setSelectedKebutuhanPelanggan(
      selectedMenu: _selectedCustomerNeedFilter,
    );
  }

  void onChangedSumberData(String value) {
    _isSumberDataValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCustomerName(String value) {
    _isCustomerNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCustomerNumber(String value) {
    _isCustomerNumberValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCompanyName(String value) {
    _isCompanyNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedPhoneNumber(String value) {
    _isPhoneNumberValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedEmail(String value) {
    _isEmailValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCity(String value) {
    _isCityValid = value.isNotEmpty;
    notifyListeners();
  }

  void setSelectedTipePelanggan({
    required int selectedMenu,
  }) {
    _selectedCustomerTypeFilter = selectedMenu;
    for (FilterOptionDynamic menu in customerTypeFilterOptions) {
      if (int.parse(menu.idFilter) == selectedMenu) {
        menu.isSelected = true;
        continue;
      }
      menu.isSelected = false;
    }

    notifyListeners();
  }

  void setSelectedKebutuhanPelanggan({
    required int selectedMenu,
  }) {
    _selectedCustomerNeedFilter = selectedMenu;
    for (FilterOptionDynamic menu in customerNeedFilterOptions) {
      if (int.parse(menu.idFilter) == selectedMenu) {
        menu.isSelected = true;
        continue;
      }
      menu.isSelected = false;
    }

    notifyListeners();
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<bool> requestUpdateCustomer() async {
    if (!_isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    final response = await _apiService.requestUpdateCustomer(
      customerId: int.parse(_customerData?.customerId ?? "0"),
      nama: namaPelangganController.text,
      customerNumber: nomorPelangganController.text,
      customerNeed: _selectedCustomerNeedFilter.toString(),
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      city: cityController.text,
      note: noteController.text,
      companyName: namaPerusahaanController.text,
      isLead: int.parse(_customerData?.isLead ?? "0") > 1
          ? 1
          : int.parse(_customerData?.isLead ?? "0"),
      dataSource: (_customerData?.isLead ?? "0") == "1"
          ? sumberDataController.text
          : "",
      customerType: _selectedCustomerTypeFilter,
    );

    if (response.isRight) {
      _msg = response.right;
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  void convertCustomerTypeDataToFilterData(List<CustomerTypeData> values) {
    if (values.isEmpty) return;

    customerTypeFilterOptions = values
        .map(
          (e) => FilterOptionDynamic(
            e.customerTypeId,
            e.customerTypeName,
            values.first == e,
          ),
        )
        .toList();

    _selectedCustomerTypeFilter = int.parse(values.first.customerTypeId);
  }

  void convertCustomerNeedDataToFilterData(List<CustomerNeedData> values) {
    if (values.isEmpty) return;

    customerNeedFilterOptions = values
        .map(
          (e) => FilterOptionDynamic(
            e.customerNeedId,
            e.customerNeedName,
            values.first == e,
          ),
        )
        .toList();

    _selectedCustomerNeedFilter = int.parse(values.first.customerNeedId);
  }

  bool _isValid() {
    _isCustomerNameValid = namaPelangganController.text.isNotEmpty;
    _isCustomerNumberValid = nomorPelangganController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    if (selectedCustomerTypeFilter == 1) {
      _isCompanyNameValid = namaPerusahaanController.text.isNotEmpty;
    }
    notifyListeners();

    if (selectedCustomerTypeFilter == 1) {
      return _isCustomerNameValid &&
          _isCustomerNumberValid &&
          _isEmailValid &&
          _isPhoneNumberValid &&
          _isCityValid;
    }

    return _isCustomerNameValid &&
        _isCustomerNumberValid &&
        _isEmailValid &&
        _isPhoneNumberValid &&
        _isCityValid;
  }

  Future<void> requestGetAllCustomerNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        List<CustomerNeedData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _listCustomerNeed = tempList;
        convertCustomerNeedDataToFilterData(tempList);
      }
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> requestGetAllCustomerType() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerTypeWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty == true) {
        List<CustomerTypeData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _listCustomerType = tempList;
        convertCustomerTypeDataToFilterData(tempList);
      }
      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }
}
