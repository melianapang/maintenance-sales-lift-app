import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  String? _msg = "";
  String? get msg => _msg;

  @override
  Future<void> initModel() async {
    setBusy(true);

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
    _selectedTipePelangganOption =
        int.parse(_customerData?.customerType ?? "0") > 1
            ? 1
            : int.parse(_customerData?.customerType ?? "0");
    _selectedKebutuhanPelangganOption =
        int.parse(_customerData?.customerNeed ?? "0") > 1
            ? 1
            : int.parse(_customerData?.customerNeed ?? "0");

    setSelectedTipePelanggan(
      selectedMenu: int.parse(_selectedTipePelangganOption.toString()),
    );
    setSelectedKebutuhanPelanggan(
      selectedMenu: int.parse(_selectedKebutuhanPelangganOption.toString()),
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
      customerNeed: _selectedKebutuhanPelangganOption.toString(),
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
      customerType: _selectedTipePelangganOption,
    );

    if (response.isRight) {
      _msg = response.right;
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  bool _isValid() {
    _isCustomerNameValid = namaPelangganController.text.isNotEmpty;
    _isCustomerNumberValid = nomorPelangganController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    if (selectedTipePelangganOption == 1) {
      _isCompanyNameValid = namaPerusahaanController.text.isNotEmpty;
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
}
