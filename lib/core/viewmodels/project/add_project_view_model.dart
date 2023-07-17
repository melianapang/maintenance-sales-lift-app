import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:intl/intl.dart';

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

  LatLng? _projectLocation;
  LatLng? get projectLocation => _projectLocation;

  String? _detectedProjectAddress;
  String? get detectedProjectAddress => _detectedProjectAddress;

  bool isLoading = false;
  bool isSearch = false;

  //region pilih customer proyek
  List<CustomerData>? _listCustomer;
  List<CustomerData>? get listCustomer => _listCustomer;

  //list distinct pic role
  List<String>? _listPICRole;
  List<String>? get listPICRole => _listPICRole;

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

  //region first follow up date
  List<DateTime> _selectedFirstFollowUpDates = [
    DateTime.now().add(
      Duration(
        days: 14,
      ),
    ),
  ];
  List<DateTime> get selectedFirstFollowUpDates => _selectedFirstFollowUpDates;

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

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;
    await requestGetAllCustomer();
    await requestGetListPICRole();

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

  void setSelectedFirstFollowUpDates(List<DateTime> value) {
    _selectedFirstFollowUpDates = value;
    notifyListeners();
  }

  void resetSearchBar() {
    searchController.text = "";
  }

  void resetPage() {
    _listCustomer = [];
    _errorMsg = null;

    _paginationControl.currentPage = 1;
    _paginationControl.totalData = -1;
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

      _isShowNoDataFoundPage = response.right.result.isEmpty == true;

      notifyListeners();
      return;
    }

    _errorMsg = response.left.message;
  }

  void setSelectedCustomerByIndex({
    required int selectedIndex,
  }) {
    _selectedCustomer = _listCustomer?[selectedIndex];
    notifyListeners();
  }

  void setSelectedCustomer(CustomerData data) {
    _selectedCustomer = data;
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
    notifyListeners();

    return _isNameValid &&
        _isAdressValid &&
        _isCityValid &&
        _projectLocation != null;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<bool> requestCreateProject() async {
    if (!isValid()) {
      _errorMsg = "Isi semua data dengan benar.";
      return false;
    }
    if (_listPic.isEmpty) {
      _errorMsg = "Belum ada PIC untuk proyek ini.";
      return false;
    }

    final response = await _apiService.requestCreateProject(
      customerId: int.parse(selectedCustomer?.customerId ?? "0"),
      projectName: nameController.text,
      projectNeed: _selectedKeperluanProyekOption,
      address: addressController.text,
      city: cityController.text,
      latitude: _projectLocation?.latitude ?? 0.0,
      longitude: _projectLocation?.longitude ?? 0.0,
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedFirstFollowUpDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
    );

    if (response.isRight) {
      _createdProjectId = response.right;
      return true;
    }

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestCreatePICs() async {
    final response = await _apiService.requestCreatePIC(
      projectId: _createdProjectId ?? 0,
      listPic: _listPic,
    );

    if (response.isRight) return true;

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
