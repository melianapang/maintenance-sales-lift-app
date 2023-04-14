import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListLogViewModel extends BaseViewModel {
  ListLogViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<LogData>? _listLogData;
  List<LogData>? get listLogData => _listLogData;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllLog();

    if (_listLogData?.isEmpty == true || _listLogData == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }

  Future<void> requestGetAllLog() async {
    final response = await _apiService.requestGetAllLog(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listLogData = response.right!;
        } else {
          _listLogData?.addAll(response.right!);
        }
        _paginationControl.currentPage += 1;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }
}
