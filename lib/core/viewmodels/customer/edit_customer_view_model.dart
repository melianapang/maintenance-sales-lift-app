import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditCustomerViewModel extends BaseViewModel {
  EditCustomerViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;

  CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  Customer? _customer;
  Customer? get customer => _customer;

  // TextEditingController

  final nomorPelangganController = TextEditingController();
  final namaPelangganController = TextEditingController();
  final namaPerusahaanController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();

  // End of TextEditingController

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
  Future<void> initModel() async {
    setBusy(true);

    if (_customerData != null) {
      _customer = _mappingCustomerDataToCustomerModel(_customerData!);
    }

    _selectedSumberDataOption = int.parse(_customerData?.dataSource ?? "0") > 1
        ? 1
        : int.parse(_customerData?.dataSource ?? "0");
    _selectedTipePelangganOption =
        int.parse(_customerData?.customerType ?? "0") > 1
            ? 1
            : int.parse(_customerData?.customerType ?? "0");
    _selectedKebutuhanPelangganOption =
        int.parse(_customerData?.customerNeed ?? "0") > 1
            ? 1
            : int.parse(_customerData?.customerNeed ?? "0");

    setSelectedTipePelanggan(
      selectedMenu: int.parse(_selectedTipePelangganOption.toString()),
    );
    setSelectedSumberData(
      selectedMenu: int.parse(_selectedSumberDataOption.toString()),
    );
    setSelectedKebutuhanPelanggan(
      selectedMenu: int.parse(_selectedKebutuhanPelangganOption.toString()),
    );

    setBusy(false);
  }

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
      customerId: _customer?.customerId ?? 0,
      nama: _customer?.customerName ?? "",
      customerNumber: _customer?.customerNumber ?? "",
      customerNeed: _customer?.customerNeed ?? "",
      email: _customer?.email ?? "",
      phoneNumber: _customer?.phoneNumber ?? "",
      city: _customer?.city ?? "",
      note: _customer?.note ?? "",
      companyName: _customer?.companyName ?? "",
      dataSource: _selectedSumberDataOption,
      customerType: _selectedTipePelangganOption,
    );

    print(
        "edit data: ${_customer?.customerName};  ${_customer?.customerType};  ${_customer?.dataSource};  ${_customer?.email};  ${_customer?.phoneNumber};  ${_customer?.companyName}; ");

    setBusy(false);
    return response != null;
  }

  Customer _mappingCustomerDataToCustomerModel(CustomerData data) {
    return Customer(
      customerId: int.parse(data.customerId),
      customerName: data.customerName,
      customerType:
          int.parse(data.customerType) > 1 ? 1 : int.parse(data.customerType),
      customerNumber: data.customerNumber,
      companyName: data.companyName,
      customerNeed: data.customerNeed,
      city: data.city,
      dataSource: int.parse(data.dataSource),
      phoneNumber: data.phoneNumber,
      note: data.note ?? "",
      status: int.parse(data.status),
      email: data.email,
    );
  }
}
