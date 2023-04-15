import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';

class AddPicProjectViewModel extends BaseViewModel {
  AddPicProjectViewModel();

  final namaPicController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

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
      ),
    );
  }
}
