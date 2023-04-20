import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class UploadDocumentViewModel extends BaseViewModel {
  UploadDocumentViewModel({
    CustomerData? customerData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData;

  final ApiService _apiService;

  final CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  final noteController = TextEditingController();

  int _selectedTipeDokumentOption = 0;
  int get selectedTipeDokumentOption => _selectedTipeDokumentOption;
  final List<FilterOption> _tipeDokumentOption = [
    FilterOption("Purchase Order", true),
    FilterOption("Quotation", false),
    FilterOption("Dokumen Perjanjian Kerja Sama", false),
  ];
  List<FilterOption> get tipeDokumentOption => _tipeDokumentOption;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void setTipeDokumen({
    required int selectedMenu,
  }) {
    _selectedTipeDokumentOption = selectedMenu;
    for (int i = 0; i < _tipeDokumentOption.length; i++) {
      if (i == selectedMenu) {
        _tipeDokumentOption[i].isSelected = true;
        continue;
      }
      _tipeDokumentOption[i].isSelected = false;
    }

    notifyListeners();
  }

  Future<bool> requestCreateCustomer() async {
    final response = await _apiService.requestCreateDocument(
      filePath: "http://www.africau.edu/images/default/sample.pdf",
      fileType: _selectedTipeDokumentOption,
      customerId: int.parse(_customerData?.customerId ?? "0"),
      note: noteController.text,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
