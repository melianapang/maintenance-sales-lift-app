import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class EditProjectViewModel extends BaseViewModel {
  EditProjectViewModel({
    required ProjectData? projectData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _projectData = projectData;

  final ApiService _apiService;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

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

  bool _isCustomerValid = true;
  bool get isCustomerValid => _isCustomerValid;
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

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _handleAvailableData();

    paginationControl.currentPage = 1;
    await requestGetAllCustomer();

    setBusy(false);
  }

  void _handleAvailableData() {
    nameController.text = _projectData?.projectName ?? "";
    cityController.text = _projectData?.city ?? "";
    addressController.text = _projectData?.address ?? "";
    _selectedKeperluanProyekOption =
        int.parse(_projectData?.projectNeed ?? "1");
    _selectedCustomer = CustomerData(
      customerId: _projectData?.customerId ?? "",
      customerNumber: "customerNumber",
      customerType: "customerType",
      customerName: _projectData?.customerName ?? "",
      customerNeed: "customerNeed",
      dataSource: "dataSource",
      city: "city",
      phoneNumber: "phoneNumber",
      email: "email",
      status: "status",
      documents: [],
    );

    setSelectedKeperluanProyek(
      selectedMenu: int.parse(_selectedKeperluanProyekOption.toString()),
    );
    notifyListeners();

    _listPic = (projectData?.pics ?? [])
        .map(
          (e) => PICProject(
            picId: e.picId,
            picName: e.picName,
            phoneNumber: e.phoneNumber,
          ),
        )
        .toList();
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
      if (response.right.result.isNotEmpty == true) {
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
    _isCustomerValid = _selectedCustomer != null;
    notifyListeners();

    return _isNameValid && _isAdressValid && _isCityValid && _isCustomerValid;
  }

  Future<bool> requestUpdateProject() async {
    if (!isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    final response = await _apiService.requestUpdateProject(
      customerId: int.parse(
        _selectedCustomer?.customerId ?? _projectData?.customerId ?? "0",
      ),
      projectName: nameController.text,
      projectNeed: _selectedKeperluanProyekOption,
      address: addressController.text,
      city: cityController.text,
      projectId: int.parse(_projectData?.projectId ?? "0"),
    );

    if (response.isRight) {
      bool isSucceedUpdatePic = await requestUpdatePIC();
      if (isSucceedUpdatePic) return true;
      return false;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestUpdatePIC() async {
    List<PICProject> newAddedPics =
        _listPic.where((element) => element.picId == null).toList();
    List<PICProject> deletedPics = [];

    final defaultPicIds = [
      for (var data in (_projectData?.pics ?? <PICProject>[])) data.picId
    ];
    final listPicIds = [for (var data in _listPic) data.picId];

    for (String? picId in defaultPicIds) {
      if (picId == null) continue;
      if (!listPicIds.contains(picId)) {
        final deleted = (_projectData?.pics ?? <PICProject>[])
            .firstWhere((element) => element.picId == picId);
        deletedPics.add(deleted);
      }
    }

    if (newAddedPics.isNotEmpty) {
      bool isSucceed = await requestCreatePICs(listAddedPic: newAddedPics);
      if (!isSucceed) return false;
    }

    if (deletedPics.isNotEmpty) {
      for (var pic in deletedPics) {
        bool isSucceed = await requestDeletePICs(
          picId: int.parse(pic.picId ?? "0"),
        );
        if (!isSucceed) return false;
      }
    }

    return true;
  }

  Future<bool> requestCreatePICs({
    required List<PICProject> listAddedPic,
  }) async {
    final response = await _apiService.requestCreatePIC(
      projectId: int.parse(_projectData?.projectId ?? "0"),
      listPic: listAddedPic,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestDeletePICs({
    required int picId,
  }) async {
    final response = await _apiService.requestDeletePIC(
      picId: picId,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
