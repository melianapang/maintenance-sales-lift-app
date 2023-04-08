import 'package:rejo_jaya_sakti_apps/core/models/approval/approval_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailApprovalViewModel extends BaseViewModel {
  DetailApprovalViewModel({
    ApprovalData? approvalData,
  }) : _approvalData = approvalData;

  ApprovalData? _approvalData;
  ApprovalData? get approvalData => _approvalData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setBusy(false);
  }
}
