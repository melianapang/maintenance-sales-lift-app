import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';

class AddPicProjectViewModel extends BaseViewModel {
  AddPicProjectViewModel();

  final namaPicController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String _name = "";
  String get name => _name;

  String _phoneNumber = "";
  String get phoneNumber => _phoneNumber;

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  @override
  Future<void> initModel() async {}

  void setName(String value) {
    _name = value;
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value.toString();
  }

  void sendDataBack(BuildContext context) {
    if (_name.isEmpty) {
      _isNameValid = false;
      notifyListeners();
      return;
    }

    if (_phoneNumber.isEmpty) {
      _isPhoneNumberValid = false;
      notifyListeners();
      return;
    }

    Navigator.pop(
      context,
      PicData(
        name: _name,
        phoneNumber: _phoneNumber,
      ),
    );
  }
}
