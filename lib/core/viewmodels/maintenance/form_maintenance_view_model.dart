import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormMaintenanceViewModel extends BaseViewModel {
  FormMaintenanceViewModel();

  // Filter related
  int _selectedHasilMaintenanceOption = 0;
  int get selectedHasilMaintenanceOption => _selectedHasilMaintenanceOption;
  final List<FilterOption> _hasilMaintenanceOption = [
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get hasilMaintenanceOption => _hasilMaintenanceOption;
  // End of filter related

  bool get isEdit => true;

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  @override
  Future<void> initModel() async {}

  void setHasilKonfirmasi(int index) {
    _selectedHasilMaintenanceOption = index;
    for (int i = 0; i < _hasilMaintenanceOption.length; i++) {
      if (i == _selectedHasilMaintenanceOption) {
        _hasilMaintenanceOption[i].isSelected = true;
        continue;
      }
      _hasilMaintenanceOption[i].isSelected = false;
    }
    notifyListeners();
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }
}
