import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailUserViewModel extends BaseViewModel {
  DetailUserViewModel({
    UserData? userData,
    required DioService dioService,
  })  : _userData = userData,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  UserData? _userData;
  UserData? get userData => _userData;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  Future<bool> requestDeleteUser() async {
    final response = await _apiService.requestDeleteUser(
      userId: int.parse(_userData?.userId ?? "0"),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
