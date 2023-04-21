import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class AddProjectViewModel extends BaseViewModel {
  AddProjectViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  List<PICProject> _listPic = [];
  List<PICProject> get listPic => _listPic;

  //region pilih customer proyek
  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;

  CustomerData? _selectedCustomer;
  CustomerData? get selectedCustomer => _selectedCustomer;
  //endregion

  //region TextController
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  bool _isAdressValid = true;
  bool get isAdressValid => _isAdressValid;

  bool _isCityValid = true;
  bool get isCityValid => _isCityValid;
  //endregion

  //region keperluan proyek
  int _selectedKeperluanProyekOption = 0;
  int get selectedKeperluanProyekOption => _selectedKeperluanProyekOption;
  final List<FilterOption> _keperluanProyekOptions = [
    FilterOption("Lift", true),
    FilterOption("Elevator", false),
    FilterOption("Lift dan Elevator", false),
    FilterOption("Lainnya", false),
  ];
  List<FilterOption> get keperluanProyekOptions => _keperluanProyekOptions;
  //endregion

  int? _createdProjectId;
  int? get createdProjectId => _createdProjectId;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllCustomer();

    setBusy(false);
  }

  void onChangedName(String value) {
    _isNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedAddress(String value) {
    _isAdressValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedCity(String value) {
    _isCityValid = value.isNotEmpty;
    notifyListeners();
  }

  Future<void> requestGetAllCustomer() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return;
    }

    final response = await _apiService.getAllCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        if (_paginationControl.currentPage == 1) {
          _listCustomer = response.right.result;
        } else {
          _listCustomer?.addAll(response.right.result);
        }

        _paginationControl.currentPage += 1;
        _paginationControl.totalData = int.parse(
          response.right.totalSize,
        );

        _isShowNoDataFoundPage =
            _listCustomer?.isEmpty == true || _listCustomer == null;

        notifyListeners();
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  void setSelectedCustomer({
    required int selectedIndex,
  }) {
    _selectedCustomer = _listCustomer?[selectedIndex];
    notifyListeners();
  }

  void setSelectedKeperluanProyek({
    required int selectedMenu,
  }) {
    _selectedKeperluanProyekOption = selectedMenu;
    for (int i = 0; i < _keperluanProyekOptions.length; i++) {
      if (i == selectedMenu) {
        _keperluanProyekOptions[i].isSelected = true;
        continue;
      }
      _keperluanProyekOptions[i].isSelected = false;
    }

    notifyListeners();
  }

  void addPicProject(PICProject value) {
    _listPic.add(value);
    notifyListeners();
  }

  void deletePicProject(int index) {
    _listPic.removeAt(index);
    notifyListeners();
  }

  bool isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid && _isAdressValid && _isCityValid;
  }

  Future<bool> requestCreateProject() async {
    if (!isValid()) {
      _errorMsg = "Isi semua data dengan benar.";
      return false;
    }

    final response = await _apiService.requestCreateProject(
      customerId: int.parse(selectedCustomer?.customerId ?? "0"),
      projectName: nameController.text,
      projectNeed: _selectedKeperluanProyekOption,
      address: addressController.text,
      city: cityController.text,
    );

    if (response.isRight) {
      _createdProjectId = response.right;
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestCreatePICs() async {
    if (_listPic.isEmpty) {
      _errorMsg = "Belum ada PIC untuk proyek ini.";
      return false;
    }

    final response = await _apiService.requestCreatePIC(
      projectId: _createdProjectId ?? 0,
      listPic: _listPic,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
