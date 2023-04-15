import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class EditUserViewModel extends BaseViewModel {
  EditUserViewModel({
    UserData? userData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _userData = userData;

  final ApiService _apiService;

  UserData? _userData;
  UserData? get userData => _userData;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final roleController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isUsernameValid = true;
  bool get isUsernameValid => _isUsernameValid;

  bool _isRoleValid = true;
  bool get isRoleValid => _isRoleValid;

  bool _isAdressValid = true;
  bool get isAdressValid => _isAdressValid;

  bool _isCityValid = true;
  bool get isCityValid => _isCityValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  bool _isEmailValid = true;
  bool get isEmailValid => _isEmailValid;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    nameController.text = _userData?.name ?? "";
    usernameController.text = _userData?.username ?? "";
    roleController.text = _userData?.roleName ?? "";
    addressController.text = _userData?.address ?? "";
    cityController.text = _userData?.city ?? "";
    phoneNumberController.text = _userData?.phoneNumber ?? "";
    emailController.text = _userData?.email ?? "";
    setBusy(false);
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedUsername(String value) {
    _isUsernameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedRole(String value) {
    _isRoleValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedAddress(String value) {
    _isAdressValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCity(String value) {
    _isCityValid = value.isNotEmpty;
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

  bool _isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isUsernameValid = usernameController.text.isNotEmpty;
    _isRoleValid = roleController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid &&
        _isUsernameValid &&
        _isRoleValid &&
        _isAdressValid &&
        _isCityValid &&
        _isPhoneNumberValid &&
        _isEmailValid;
  }

  Future<bool> requestEditUser() async {
    if (!_isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    final response = await _apiService.requestUpdateUser(
        userId: int.parse(_userData?.userId ?? "0"),
        idRole: (mappingStringToRole(
              _userData?.roleName ?? "",
            ).index) +
            1,
        name: nameController.text,
        username: usernameController.text,
        phoneNumber: phoneNumberController.text,
        address: addressController.text,
        city: cityController.text,
        email: emailController.text);

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
