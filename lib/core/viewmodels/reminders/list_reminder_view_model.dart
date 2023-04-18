import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ListReminderViewModel extends BaseViewModel {
  ListReminderViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<ReminderData> _listReminder = [];
  List<ReminderData> get listReminder => _listReminder;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _paginationControl.currentPage = 1;

    await requestGetAllReminderData();
    if (_listReminder.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }

  Future<void> requestGetAllReminderData() async {
    final response = await _apiService.requestGetAllReminder(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listReminder = response.right!;
        } else {
          _listReminder.addAll(response.right!);
        }
        _paginationControl.currentPage += 1;
        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  Future<void> refreshPage() async {
    setBusy(true);

    _listReminder = [];

    paginationControl.currentPage = 1;
    await requestGetAllReminderData();

    if (_listReminder.isEmpty) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }
    setBusy(false);
  }
}
