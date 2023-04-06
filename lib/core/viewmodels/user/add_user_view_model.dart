import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class AddUserViewModel extends BaseViewModel {
  AddUserViewModel();

  String _name = "";
  String get name => _name;

  String _role = "";
  String get role => _role;

  String _address = "";
  String get address => _address;

  String _city = "";
  String get city => _city;

  String _phoneNumber = "";
  String get phoneNumber => _phoneNumber;

  String _email = "";
  String get email => _email;

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
  Future<void> initModel() async {}

  void setName({required String value}) {
    _name = value;

    _isNameValid = _name.isNotEmpty;
    notifyListeners();
  }

  void setRole({required String value}) {
    _role = value;

    _isRoleValid = _role.isNotEmpty;
    notifyListeners();
  }

  void setAddress({required String value}) {
    _address = value;

    _isAdressValid = _address.isNotEmpty;
    notifyListeners();
  }

  void setCity({required String value}) {
    _city = value;

    _isCityValid = _city.isNotEmpty;
    notifyListeners();
  }

  void setPhoneNumber({required String value}) {
    _phoneNumber = value;

    _isPhoneNumberValid = _phoneNumber.isNotEmpty;
    notifyListeners();
  }

  void setEmail({required String value}) {
    _email = value;

    _isEmailValid = _email.isNotEmpty;
    notifyListeners();
  }

  bool saveData() {
    _isNameValid = _name.isNotEmpty;
    _isRoleValid = _role.isNotEmpty;
    _isAdressValid = _address.isNotEmpty;
    _isCityValid = _city.isNotEmpty;
    _isPhoneNumberValid = _phoneNumber.isNotEmpty;
    _isEmailValid = _email.isNotEmpty;
    notifyListeners();

    return _isNameValid &&
        _isRoleValid &&
        _isAdressValid &&
        _isCityValid &&
        _isPhoneNumberValid &&
        _isEmailValid;
  }
}
