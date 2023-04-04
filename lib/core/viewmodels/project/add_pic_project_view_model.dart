import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';

class AddPicProjectViewModel extends BaseViewModel {
  AddPicProjectViewModel();

  String _name = "";
  String get name => _name;

  String _phoneNumber = "";
  String get phoneNumber => _phoneNumber;

  @override
  Future<void> initModel() async {}

  void setName(String value) {
    _name = value;
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
  }

  void sendDataBack(BuildContext context) {
    Navigator.pop(
      context,
      PicData(
        name: _name,
        phoneNumber: _phoneNumber,
      ),
    );
  }
}
