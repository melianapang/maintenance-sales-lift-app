import 'package:flutter/material.dart';
import 'package:gcloud/http.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
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

  // Dropdown related
  int _selectedKebutuhanPelangganOption = 0;
  int get selectedKebutuhanPelangganOption => _selectedKebutuhanPelangganOption;
  final List<FilterOption> _kebutuhanPelangganOptions = [
    FilterOption("Pembelian Unit", true),
    FilterOption("Perawatan/Troubleshooting", false),
  ];
  List<FilterOption> get kebutuhanPelangganOptions =>
      _kebutuhanPelangganOptions;

  int _selectedTipePelangganOption = 0;
  int get selectedTipePelangganOption => _selectedTipePelangganOption;
  final List<FilterOption> _tipePelangganOptions = [
    FilterOption("Perorangan", true),
    FilterOption("Perusahaan", false),
  ];
  List<FilterOption> get tipePelangganOptions => _tipePelangganOptions;
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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
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
    _selectedTipePelangganOption = selectedMenu;
    for (int i = 0; i < _tipePelangganOptions.length; i++) {
      if (i == selectedMenu) {
        _tipePelangganOptions[i].isSelected = true;
        continue;
      }
      _tipePelangganOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void setSelectedKebutuhanPelanggan({
    required int selectedMenu,
  }) {
    _selectedKebutuhanPelangganOption = selectedMenu;
    for (int i = 0; i < _kebutuhanPelangganOptions.length; i++) {
      if (i == selectedMenu) {
        _kebutuhanPelangganOptions[i].isSelected = true;
        continue;
      }
      _kebutuhanPelangganOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  bool isValid() {
    _isCustomerNameValid = customerNameController.text.isNotEmpty;
    _isCustomerNumberValid = customerNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    if (selectedTipePelangganOption == 1) {
      _isCompanyNameValid = companyNameController.text.isNotEmpty;
    }
    notifyListeners();

    if (selectedTipePelangganOption == 1) {
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

  // @TODO(meli): change into Future<CustomerData> obj later // wait for BE
  Future<CustomerData?> requestCreateCustomer() async {
    if (!isValid()) {
      _errorMsg = "Isi semua data dengan benar.";
      return null;
    }

    final response = await _apiService.requestCreateCustomer(
      nama: customerNameController.text,
      customerNumber: customerNumberController.text,
      customerType: _selectedTipePelangganOption,
      customerNeed: _selectedKebutuhanPelangganOption.toString(),
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
      // @TODO(meli): change into this later // wait for BE
      // return response.right.customer;
    }

    _errorMsg = response.left.message;
    return null;
  }
}
