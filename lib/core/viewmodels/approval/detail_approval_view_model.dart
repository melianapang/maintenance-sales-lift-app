import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/approval/approval_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailApprovalViewModel extends BaseViewModel {
  DetailApprovalViewModel({
    ApprovalData? approvalData,
    required DioService dioService,
  })  : _approvalData = approvalData,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  ApprovalData? _approvalData;
  ApprovalData? get approvalData => _approvalData;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }

  Future<bool> requestChangeApprovalStatus({
    required bool isApprove,
  }) async {
    final response = await _apiService.requestUpdateApproval(
      approvalId: int.parse(_approvalData?.approvalId ?? "0"),
      approvalStatus: isApprove ? 1 : 2,
    );
    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
