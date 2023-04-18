import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListCustomerViewModel extends BaseViewModel {
  ListCustomerViewModel({
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;

  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  bool _isAllowedToExportData = false;
  bool get isAllowedToExportData => _isAllowedToExportData;

  // Filter related
  int _selectedTipePelangganOption = 0;
  int get selectedTipePelangganOption => _selectedTipePelangganOption;
  final List<FilterOption> _tipePelangganOptions = [
    FilterOption("Perorangan", true),
    FilterOption("Perusahaan", false),
  ];
  List<FilterOption> get tipePelangganOptions => _tipePelangganOptions;

  int _selectedSumberDataOption = 0;
  int get selectedSumberDataOption => _selectedSumberDataOption;
  final List<FilterOption> _sumberDataOptions = [
    FilterOption("Lead", true),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get sumberDataOptions => _sumberDataOptions;

  int _selectedTahapKonfirmasiOption = 0;
  int get selectedTahapKonfirmasiOption => _selectedTahapKonfirmasiOption;
  final List<FilterOption> _tahapKonfirmasiOptions = [
    FilterOption("Butuh Konfirmasi", true),
    FilterOption("Konfirmasi kedua", false),
    FilterOption("Konfirmasi ketiga", false),
    FilterOption("Nego", false),
    FilterOption("Instalasi", false),
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get tahapKonfirmasiOptions => _tahapKonfirmasiOptions;

  int _selectedKebutuhanPelangganOption = 0;
  int get selectedKebutuhanPelangganOption => _selectedKebutuhanPelangganOption;
  final List<FilterOption> _kenbutuhanPelangganOptions = [
    FilterOption("Butuh Konfirmasi", true),
    FilterOption("Konfirmasi kedua", false),
    FilterOption("Konfirmasi ketiga", false),
    FilterOption("Nego", false),
    FilterOption("Instalasi", false),
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get kenbutuhanPelangganOptions =>
      _kenbutuhanPelangganOptions;

  int _selectedSortOption = 0;
  int get selectedSortOption => _selectedSortOption;
  final List<FilterOption> _sortOptions = [
    FilterOption("Ascending", true),
    FilterOption("Descending", false),
  ];
  List<FilterOption> get sortOptions => _sortOptions;
  // End of filter related

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllCustomer();
    if (_listCustomer?.isEmpty == true || _listCustomer == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    _isAllowedToExportData = await isUserAllowedToExportData();

    setBusy(false);
  }

  void search(String text) {
    if (busy || _listCustomer?.isEmpty == true || _listCustomer == null) return;
    setBusy(true);

    setBusy(false);
  }

  Future<void> requestGetAllCustomer() async {
    final response = await _apiService.getAllCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right != null || response.right?.isNotEmpty == true) {
        if (_paginationControl.currentPage == 1) {
          _listCustomer = response.right!;
        } else {
          _listCustomer?.addAll(response.right!);
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

    _listCustomer = [];

    paginationControl.currentPage = 1;

    await requestGetAllCustomer();
    if (_listCustomer?.isEmpty == true || _listCustomer == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

    setBusy(false);
  }

  Future<bool> isUserAllowedToExportData() async {
    Role role = await _authenticationService.getUserRole();
    return role == Role.Admin;
  }

  void terapkanFilter({
    required int selectedPelanggan,
    required int selectedSumberData,
    required int selectedTahapKonfirmasi,
    required int selectedKebutuhanPelanggan,
    required int selectedSort,
  }) {
    _selectedTipePelangganOption = selectedPelanggan;
    _selectedSumberDataOption = selectedSumberData;
    _selectedTahapKonfirmasiOption = selectedTahapKonfirmasi;
    _selectedKebutuhanPelangganOption = selectedKebutuhanPelanggan;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _tipePelangganOptions.length; i++) {
      if (i == selectedPelanggan) {
        _tipePelangganOptions[i].isSelected = true;
        continue;
      }
      _tipePelangganOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sumberDataOptions.length; i++) {
      if (i == selectedSumberData) {
        _sumberDataOptions[i].isSelected = true;
        continue;
      }
      _sumberDataOptions[i].isSelected = false;
    }

    for (int i = 0; i < _tahapKonfirmasiOptions.length; i++) {
      if (i == selectedTahapKonfirmasi) {
        _tahapKonfirmasiOptions[i].isSelected = true;
        continue;
      }
      _tahapKonfirmasiOptions[i].isSelected = false;
    }

    for (int i = 0; i < _kenbutuhanPelangganOptions.length; i++) {
      if (i == selectedKebutuhanPelanggan) {
        _kenbutuhanPelangganOptions[i].isSelected = true;
        continue;
      }
      _kenbutuhanPelangganOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sortOptions.length; i++) {
      if (i == selectedSort) {
        _sortOptions[i].isSelected = true;
        continue;
      }
      _sortOptions[i].isSelected = false;
    }
    notifyListeners();
  }
}
