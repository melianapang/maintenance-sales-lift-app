import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditCustomerViewModel extends BaseViewModel {
  EditCustomerViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  String _nama = "";
  String get nama => _nama;

  String _custNumber = "";
  String get custNumber => _custNumber;

  String _email = "";
  String get email => _email;

  String _phoneNumber = "";
  String get phoneNumber => _phoneNumber;

  String _city = "";
  String get city => _city;

  String _companyName = "Hello789";
  String get companyName => _companyName;

  String _dataSource = "Hello789";
  String get dataSource => _dataSource;

  String _note = "Uname22";
  String get note => _note;

  // Dropdown related
  int _selectedSumberDataOption = 0;
  int get selectedSumberDataOption => _selectedSumberDataOption;
  final List<FilterOption> _sumberDataOptions = [
    FilterOption("Leads", true),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get sumberDataOptions => _sumberDataOptions;

  int _selectedKebutuhanPelangganOption = 0;
  int get selectedKebutuhanPelangganOption => _selectedKebutuhanPelangganOption;
  final List<FilterOption> _kebutuhanPelangganOptions = [
    FilterOption("Pembelian Unit", true),
    FilterOption("Perawatan/Troubleshooting", false),
  ];
  List<FilterOption> get kebutuhanPelangganOptions =>
      _kebutuhanPelangganOptions;

  int _selectedTipePelangganOption = 0;
  int get selectedTipePelangganOption => _selectedTipePelangganOption;
  final List<FilterOption> _tipePelangganOptions = [
    FilterOption("Perorangan", true),
    FilterOption("Perusahaan", false),
  ];
  List<FilterOption> get tipePelangganOptions => _tipePelangganOptions;
  // End of Dropdown related

  @override
  Future<void> initModel() async {}

  void setSelectedSumberData({
    required int selectedMenu,
  }) {
    _selectedSumberDataOption = selectedMenu;
    for (int i = 0; i < _sumberDataOptions.length; i++) {
      if (i == selectedMenu) {
        _sumberDataOptions[i].isSelected = true;
        continue;
      }
      _sumberDataOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void setSelectedTipePelanggan({
    required int selectedMenu,
  }) {
    _selectedTipePelangganOption = selectedMenu;
    for (int i = 0; i < _tipePelangganOptions.length; i++) {
      if (i == selectedMenu) {
        _tipePelangganOptions[i].isSelected = true;
        continue;
      }
      _tipePelangganOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void setSelectedKebutuhanPelanggan({
    required int selectedMenu,
  }) {
    _selectedKebutuhanPelangganOption = selectedMenu;
    for (int i = 0; i < _kebutuhanPelangganOptions.length; i++) {
      if (i == selectedMenu) {
        _kebutuhanPelangganOptions[i].isSelected = true;
        continue;
      }
      _kebutuhanPelangganOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  Future<bool> requestUpdateCustomer() async {
    setBusy(true);
    final response = await _apiService.requestUpdateCustomer(
      nama: _nama,
      customerNumber: _custNumber,
      email: _email,
      phoneNumber: _phoneNumber,
      city: _city,
      note: _note,
      companyName: _companyName,
      dataSource: _selectedSumberDataOption,
      customerType: _selectedTipePelangganOption,
    );

    setBusy(false);
    return response != null;
  }
}
