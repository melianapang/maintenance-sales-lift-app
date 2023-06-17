import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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

  bool isLoading = false;
  bool isSearch = false;

  //region pilih customer proyek
  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  //list distinct pic role
  List<String>? _listPICRole;
  List<String>? get listPICRole => _listPICRole;

  CustomerData? _selectedCustomer;
  CustomerData? get selectedCustomer => _selectedCustomer;

  LatLng? _projectLocation;
  LatLng? get projectLocation => _projectLocation;

  PaginationControl _paginationControl = PaginationControl();
  PaginationControl get paginationControl => _paginationControl;

  bool _isShowNoDataFoundPage = false;
  bool get isShowNoDataFoundPage => _isShowNoDataFoundPage;
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

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    _handleAvailableData();

    paginationControl.currentPage = 1;
    await requestGetAllCustomer();
    await requestGetListPICRole();

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
      isLead: "isLead",
      city: "city",
      phoneNumber: "phoneNumber",
      email: "email",
      status: "status",
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
            email: e.email,
            role: e.role,
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

  Future<List<CustomerData>> searchOnChanged() async {
    final Completer<bool> completer = Completer<bool>();

    isLoading = true;
    if (isSearch) resetPage();

    if (searchController.text.isEmpty) {
      await requestGetAllCustomer();

      isLoading = false;
      completer.complete(true);
      return _listCustomer ?? [];
    }

    invokeDebouncer(
      () async {
        await searchCustomer();
        isLoading = false;
        completer.complete(true);
      },
    );
    await completer.future;
    return _listCustomer ?? [];
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
      }

      _isShowNoDataFoundPage = response.right.result.isEmpty == true ||
          _listCustomer?.isEmpty == true ||
          _listCustomer == null;
      notifyListeners();

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

  void pinProjectLocation(LatLng value) {
    _projectLocation = value;
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

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void resetPage() {
    _listCustomer = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
  }

  Future<List<CustomerData>> searchCustomer() async {
    if (_paginationControl.totalData != -1 &&
        _paginationControl.totalData <=
            (_paginationControl.currentPage - 1) *
                _paginationControl.pageSize) {
      return [];
    }

    final response = await _apiService.searchCustomer(
      currentPage: _paginationControl.currentPage,
      pageSize: _paginationControl.pageSize,
      inputUser: searchController.text,
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
      }
      _isShowNoDataFoundPage = response.right.result.isEmpty;
      notifyListeners();

      return _listCustomer ?? [];
    }

    _errorMsg = response.left.message;
    _isShowNoDataFoundPage = true;
    notifyListeners();
    return [];
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
      longitude: _projectLocation?.longitude ?? 0.0,
      latitude: _projectLocation?.latitude ?? 0.0,
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

  Future<void> requestGetListPICRole() async {
    final response = await _apiService.requestGetDistinctPICRoles();

    if (response.isRight) {
      if (response.right.isNotEmpty) {
        _listPICRole = response.right;
      }
      return;
    }

    _errorMsg = response.left.message;
  }

  void invokeDebouncer(Function() function) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(
        milliseconds: 300,
      ),
      function,
    );
  }
}
