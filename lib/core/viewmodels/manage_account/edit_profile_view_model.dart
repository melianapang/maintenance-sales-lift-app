import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class EditProfileViewModel extends BaseViewModel {
  EditProfileViewModel({
    ProfileData? profileData,
    required DioService dioService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _profileData = profileData,
        _sharedPreferencesService = sharedPreferencesService;

  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferencesService;

  final ProfileData? _profileData;
  ProfileData? get profileData => _profileData;

  final namaLengkapController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final alamatController = TextEditingController();
  final kotaController = TextEditingController();
  final emailController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isAdressValid = true;
  bool get isAdressValid => _isAdressValid;

  bool _isCityValid = true;
  bool get isCityValid => _isCityValid;

  bool _isPhoneNumberValid = true;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  bool _isEmailValid = true;
  bool get isEmailValid => _isEmailValid;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    handleExistingData();
    setBusy(false);
  }

  void handleExistingData() {
    namaLengkapController.text = _profileData?.name ?? "";
    phoneNumberController.text = _profileData?.phoneNumber ?? "";
    alamatController.text = _profileData?.address ?? "";
    kotaController.text = _profileData?.city ?? "";
    emailController.text = _profileData?.email ?? "";
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
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
    _isNameValid = namaLengkapController.text.isNotEmpty;
    _isAdressValid = alamatController.text.isNotEmpty;
    _isCityValid = kotaController.text.isNotEmpty;
    _isPhoneNumberValid = phoneNumberController.text.isNotEmpty;
    _isEmailValid = emailController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid &&
        _isAdressValid &&
        _isCityValid &&
        _isPhoneNumberValid &&
        _isEmailValid;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<void> _saveNewData() async {
    await _sharedPreferencesService.set(
      SharedPrefKeys.profileData,
      ProfileData(
        username: _profileData?.username ?? "",
        name: namaLengkapController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        address: alamatController.text,
        city: kotaController.text,
        role: _profileData?.role ?? Role.Engineers,
      ),
    );
  }

  Future<bool> requestUpdateUser() async {
    if (!_isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    String userId = await _sharedPreferencesService.get(SharedPrefKeys.userId);

    final response = await _apiService.requestUpdateUser(
      userId: int.parse(userId),
      //default if null: Role.Engineer
      idRole: (_profileData?.role.index ?? 3) + 1,
      name: namaLengkapController.text,
      username: usernameController.text,
      phoneNumber: phoneNumberController.text,
      address: alamatController.text,
      city: kotaController.text,
      email: emailController.text,
    );

    if (response.isRight) {
      await _saveNewData();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }
}
