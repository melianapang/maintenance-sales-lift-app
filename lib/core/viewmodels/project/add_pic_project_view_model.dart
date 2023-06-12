import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class AddPicProjectViewModel extends BaseViewModel {
  AddPicProjectViewModel({
    required List<String>? listRole,
  }) : _listRole = listRole;

  bool isLoading = false;
  bool isSearch = false;

  List<String>? _listRole;
  List<String>? get listRole => _listRole;

  List<String>? _listSearchedRole;
  List<String>? get listSearchedRole => _listSearchedRole;

  String? _selectedRole;
  String? get selectedRole => _selectedRole;

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  final namaPicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  bool _isEmailValid = true;
  bool get isEmailValid => _isEmailValid;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
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

  void setSelectedRole({
    required String selectedRole,
  }) {
    _selectedRole = selectedRole;
    notifyListeners();
  }

  Future<List<String>> searchOnChanged() async {
    isLoading = true;
    if (searchController.text.isEmpty) {
      _listSearchedRole = _listRole?.toList();

      isLoading = false;
      return _listSearchedRole ?? [];
    }

    return _listSearchedRole =
        _listRole?.where((e) => e.contains(searchController.text)).toList() ??
            [];
  }

  void sendDataBack(BuildContext context) {
    if (namaPicController.text.isEmpty) {
      _isNameValid = false;
      notifyListeners();
      return;
    }

    if (phoneNumberController.text.isEmpty) {
      _isPhoneNumberValid = false;
      notifyListeners();
      return;
    }

    Navigator.pop(
      context,
      PICProject(
        picName: namaPicController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
        role: _selectedRole ?? "",
      ),
    );
  }
}
