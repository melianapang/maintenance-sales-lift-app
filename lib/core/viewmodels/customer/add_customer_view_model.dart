import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_type_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class AddCustomerViewModel extends BaseViewModel {
  AddCustomerViewModel({
    required AuthenticationService authenticationService,
    required DioService dioService,
  })  : _authenticationService = authenticationService,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;
  final AuthenticationService _authenticationService;

  bool _isSumberDataFieldVisible = true;
  bool get isSumberDataFieldVisible => _isSumberDataFieldVisible;

  // Dropdown related (dynamic values from API)
  int _selectedCustomerNeedFilter = 0;
  int get selectedCustomerNeedFilter => _selectedCustomerNeedFilter;

  List<CustomerNeedData>? _listCustomerNeed;
  List<CustomerNeedData>? get listCustomerNeed => _listCustomerNeed;
  List<FilterOptionDynamic> customerNeedFilterOptions = [];

  int _selectedCustomerTypeFilter = 0;
  int get selectedCustomerTypeFilter => _selectedCustomerTypeFilter;

  String _selectedCustomerTypeFilterStr = "";
  String get selectedCustomerTypeFilterStr => _selectedCustomerTypeFilterStr;

  List<CustomerTypeData>? _listCustomerType;
  List<CustomerTypeData>? get listCustomerType => _listCustomerType;
  List<FilterOptionDynamic> customerTypeFilterOptions = [];
  // End of Dropdown related

  //region TextController
  final sumberDataController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();
  final cityController = TextEditingController();

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
  //endregion

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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await requestGetAllCustomerNeed();
    await requestGetAllCustomerType();
    await _isSumberDataFieldVisibility();
    setBusy(false);
  }

  Future<void> _isSumberDataFieldVisibility() async {
    Role userRole = await _authenticationService.getUserRole();
    switch (userRole) {
      case Role.SuperAdmin:
      case Role.Admin:
        _isSumberDataFieldVisible = true;
        break;
      case Role.Engineers:
        break;
      case Role.Sales:
      default:
        _isSumberDataFieldVisible = false;
        break;
    }
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
        _selectedCustomerTypeFilterStr = menu.title;
        notifyListeners();
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
    _selectedCustomerTypeFilterStr = values.first.customerTypeName;
    notifyListeners();
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

  bool isValid() {
    _isCustomerNameValid = customerNameController.text.isNotEmpty;
    _isCustomerNumberValid = customerNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    if (selectedCustomerTypeFilter == 1) {
      _isCompanyNameValid = companyNameController.text.isNotEmpty;
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

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<CustomerData?> requestCreateCustomer() async {
    if (!isValid()) {
      _errorMsg = "Isi semua data dengan benar.";
      return null;
    }

    final response = await _apiService.requestCreateCustomer(
      nama: customerNameController.text,
      customerNumber: customerNumberController.text,
      customerType: _selectedCustomerTypeFilter,
      customerNeed: _selectedCustomerNeedFilter.toString(),
      isLead: isSumberDataFieldVisible ? "1" : "0",
      dataSource: sumberDataController.text,
      email: emailController.text,
      companyName: companyNameController.text,
      phoneNumber: phoneNumberController.text,
      note: noteController.text,
      city: cityController.text,
    );

    if (response.isRight) {
      return response.right.data.customerData;
    }

    _errorMsg = response.left.message;
    return null;
  }

  Future<bool> requestGetAllCustomerNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        List<CustomerNeedData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _listCustomerNeed = tempList;
        convertCustomerNeedDataToFilterData(tempList);
      }
      notifyListeners();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestGetAllCustomerType() async {
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
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }
}
