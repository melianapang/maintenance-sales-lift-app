import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/pagination_control_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';
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

  List<PicData> _listPic = [];
  List<PicData> get listPic => _listPic;

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

  @override
  Future<void> initModel() async {
    setBusy(true);

    paginationControl.currentPage = 1;

    await requestGetAllCustomer();
    if (_listCustomer?.isEmpty == true || _listCustomer == null) {
      _isShowNoDataFoundPage = true;
      notifyListeners();
    }

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
    List<CustomerData>? list = await _apiService.getAllCustomer(
      _paginationControl.currentPage,
      _paginationControl.pageSize,
    );

    if (list != null || list?.isNotEmpty == true) {
      if (_paginationControl.currentPage == 1) {
        _listCustomer = list;
      } else {
        _listCustomer?.addAll(list!);
      }
      _paginationControl.currentPage += 1;
      notifyListeners();
    }
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

  void addPicProject(PicData value) {
    _listPic.add(value);
    notifyListeners();
  }

  void deletePicProject(int index) {
    _listPic.removeAt(index);
    notifyListeners();
  }

  bool saveData() {
    _isNameValid = nameController.text.isNotEmpty;
    _isAdressValid = addressController.text.isNotEmpty;
    _isCityValid = cityController.text.isNotEmpty;
    notifyListeners();

    return _isNameValid && _isAdressValid && _isCityValid;
  }
}
