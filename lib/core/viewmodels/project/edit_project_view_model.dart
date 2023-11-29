import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_need_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/location_utils.dart';
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

  String? _detectedProjectAddress;
  String? get detectedProjectAddress => _detectedProjectAddress;

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
  List<CustomerNeedData>? _keperluanProyekOptions;
  List<CustomerNeedData>? get keperluanProyekOptions => _keperluanProyekOptions;
  List<FilterOptionDynamic> keperluanProyekFilterOptions = [];

  String get customerNeed {
    if (keperluanProyekFilterOptions.isEmpty) return "";

    final int index = keperluanProyekFilterOptions.indexWhere((element) =>
        int.parse(element.idFilter) == _selectedKeperluanProyekOption);
    if (index > -1) {
      return keperluanProyekFilterOptions[index].title;
    }
    return "";
  }
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
    await requestGetAllProjectNeed();
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
      salesOwnedId: _projectData?.salesOwnedId ?? "",
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

    if (_projectData?.latitude != null && _projectData?.longitude != null) {
      _projectLocation = LatLng(
        double.parse(_projectData?.latitude ?? "0.0"),
        double.parse(_projectData?.longitude ?? "0.0"),
      );
    }
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

  void setSelectedCustomer(CustomerData data) {
    _selectedCustomer = data;
    notifyListeners();
  }

  Future<Position?> getCurrentPosition() async {
    return await LocationUtils.getCurrentPosition();
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

  void setSelectedKeperluanProyek({
    required int selectedMenu,
  }) {
    _selectedKeperluanProyekOption = selectedMenu;
    for (FilterOptionDynamic menu in keperluanProyekFilterOptions) {
      if (int.parse(menu.idFilter) == selectedMenu) {
        menu.isSelected = true;
        continue;
      }
      menu.isSelected = false;
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

  void pinProjectLocation(LatLng value) async {
    _projectLocation = value;

    //get detected address
    List<Placemark> locations = await placemarkFromCoordinates(
      value.latitude,
      value.longitude,
      localeIdentifier: "en",
    );
    _detectedProjectAddress =
        "${locations.first.street}, ${locations.first.locality}, ${locations.first.country}";

    notifyListeners();
  }

  bool isValid() {
    _isNameValid = nameController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    _isCustomerValid = _selectedCustomer != null;
    notifyListeners();

    return _isNameValid &&
        _isAdressValid &&
        _isCityValid &&
        _isCustomerValid &&
        _projectLocation != null;
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

  void convertProjectNeedDataToFilterData(List<CustomerNeedData> values) {
    if (values.isEmpty) return;

    keperluanProyekFilterOptions = values
        .map(
          (e) => FilterOptionDynamic(
            e.customerNeedId,
            e.customerNeedName,
            values.first == e,
          ),
        )
        .toList();

    _selectedKeperluanProyekOption = int.parse(values.first.customerNeedId);
  }

  Future<bool> requestGetAllProjectNeed() async {
    _errorMsg = null;

    final response = await _apiService.getAllCustomerNeedWithoutPagination();

    if (response.isRight) {
      if (response.right.result.isNotEmpty) {
        List<CustomerNeedData> tempList = response.right.result
            .where((element) => element.isActive == "1")
            .toList();
        _keperluanProyekOptions = tempList;
        convertProjectNeedDataToFilterData(tempList);
      }
      notifyListeners();
      return true;
    }

    _errorMsg = response.left.message;
    return false;
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
      if (_paginationControl.currentPage == 1) {
        _listCustomer = response.right.result;
      } else {
        _listCustomer?.addAll(response.right.result);
      }

      if (response.right.result.isNotEmpty) {
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
