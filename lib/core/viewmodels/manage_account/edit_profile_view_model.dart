import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
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
}
