import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ExportDataMaintenanceViewModel extends BaseViewModel {
  ExportDataMaintenanceViewModel();

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  @override
  Future<void> initModel() async {}

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }
}
