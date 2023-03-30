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

  ProfileData? _profileData;
  ProfileData? get profileData => _profileData;

  @override
  Future<void> initModel() async {}

  void setUsername(String value) {
    _profileData?.username = value;
  }

  void setAddress(String value) {
    _profileData?.address = value;
  }

  void setEmail(String value) {
    _profileData?.email = value;
  }

  void setCity(String value) {
    _profileData?.city = value;
  }

  void setPhoneNumber(String value) {
    _profileData?.phoneNumber = value;
  }

  void setRole(String value) {
    _profileData?.role = mappingStringToRole(value);
  }
}
