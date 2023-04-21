import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/approval/approval_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListApprovalViewModel extends BaseViewModel {
  ListApprovalViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<ApprovalData>? _listApproval = [];
  List<ApprovalData>? get listApproval => _listApproval;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllApproval();
    _isShowNoDataFoundPage =
        _listApproval?.isEmpty == true || _listApproval == null;
    notifyListeners();

    setBusy(false);
  }

  Future<void> requestGetAllApproval() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.requestGetAllApproval(
      pageSize: _paginationControl.pageSize,
      currentPage: _paginationControl.currentPage,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listApproval = response.right.result;
        } else {
          _listApproval?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    _listApproval = [];
    _errorMsg = null;

    paginationControl.currentPage = 1;
    await requestGetAllApproval();
    _isShowNoDataFoundPage =
        _listApproval?.isEmpty == true || _listApproval == null;
    notifyListeners();

    setBusy(false);
  }
}
