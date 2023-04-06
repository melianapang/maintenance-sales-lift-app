import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class EditProfileViewModel extends BaseViewModel {
  EditProfileViewModel({
    ProfileData? profileData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _profileData = profileData;

  final ApiService _apiService;

  final ProfileData? _profileData;

  final namaLengkapController = TextEditingController();
  final peranController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final alamatController = TextEditingController();
  final kotaController = TextEditingController();
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
    handleExistingData();
    setBusy(false);
  }

  void handleExistingData() {
    namaLengkapController.text = _profileData?.firstName ?? "";
    peranController.text = mappingRoleToString(
      _profileData?.role ?? Role.Sales,
    );
    phoneNumberController.text = _profileData?.phoneNumber ?? "";
    alamatController.text = _profileData?.address ?? "";
    kotaController.text = _profileData?.city ?? "";
    emailController.text = _profileData?.email ?? "";
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
    _isNameValid = namaLengkapController.text.isNotEmpty;
    _isRoleValid = peranController.text.isNotEmpty;
    _isAdressValid = alamatController.text.isNotEmpty;
    _isCityValid = kotaController.text.isNotEmpty;
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
