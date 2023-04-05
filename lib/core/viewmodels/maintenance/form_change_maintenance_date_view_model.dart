import 'dart:io';

import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class FormChangeMaintenanceDateViewModel extends BaseViewModel {
  FormChangeMaintenanceDateViewModel({
    MaintenanceData? maintenanceData,
  }) : _maintenanceData = maintenanceData;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  List<DateTime> _selectedNextMaintenanceDates = [
    DateTime.now().add(
      Duration(
        days: 7,
      ),
    ),
  ];
  List<DateTime> get selectedNextMaintenanceDates =>
      _selectedNextMaintenanceDates;

  @override
  Future<void> initModel() async {}

  void setSelectedNextMaintenanceDates(List<DateTime> value) {
    _selectedNextMaintenanceDates = value;
    notifyListeners();
  }
}
