import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class EditUserViewModel extends BaseViewModel {
  EditUserViewModel({
    UserData? userData,
  }) : _userData = userData;

  UserData? _userData;
  UserData? get userData => _userData;

  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

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

  @override
  Future<void> initModel() async {
    setBusy(true);
    nameController.text = _userData?.name ?? "";
    roleController.text = _userData?.roleName ?? "";
    addressController.text = _userData?.address ?? "";
    cityController.text = _userData?.city ?? "";
    phoneNumberController.text = _userData?.city ?? "";
    emailController.text = _userData?.email ?? "";
    setBusy(false);
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
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

  bool saveData() {
    _isNameValid = nameController.text.isNotEmpty;
    _isRoleValid = roleController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid &&
        _isRoleValid &&
        _isAdressValid &&
        _isCityValid &&
        _isPhoneNumberValid &&
        _isEmailValid;
  }
}
