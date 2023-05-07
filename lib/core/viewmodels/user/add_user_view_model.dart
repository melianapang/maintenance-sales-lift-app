import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class AddUserViewModel extends BaseViewModel {
  AddUserViewModel({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  Role? userRole;

  // Dropdown related
  int _selectedRoleOption = 0;
  int get selectedRoleOption => _selectedRoleOption;
  final List<FilterOption> _roleOptions = [
    FilterOption("Super Admin", true),
    FilterOption("Admin", false),
    FilterOption("Sales", false),
    FilterOption("Teknisi", false),
  ];
  List<FilterOption> get roleOptions => _roleOptions;
  //End of Dropdown related

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isUsernameValid = true;
  bool get isUsernameValid => _isUsernameValid;

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
    userRole = await _authenticationService.getUserRole();
    //update role option
    if (userRole == Role.Admin) {
      _roleOptions.removeAt(0);
      _roleOptions.first.isSelected = true;
    }
    setBusy(false);
  }

  Role getSelectedRole() {
    return mappingStringNumberToRole(
      (selectedRoleOption + (userRole == Role.Admin ? 2 : 1)).toString(),
    );
  }

  void setSelectedRole({
    required int selectedMenu,
  }) {
    _selectedRoleOption = selectedMenu;
    for (int i = 0; i < _roleOptions.length; i++) {
      if (i == selectedMenu) {
        _roleOptions[i].isSelected = true;
        continue;
      }
      _roleOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedUsername(String value) {
    _isUsernameValid = value.isNotEmpty;
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

  bool isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isUsernameValid = usernameController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid &&
        _isUsernameValid &&
        _isAdressValid &&
        _isCityValid &&
        _isPhoneNumberValid &&
        _isEmailValid;
  }
}
