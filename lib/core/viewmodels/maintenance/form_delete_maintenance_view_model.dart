import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class FormDeleteMaintenanceViewModel extends BaseViewModel {
  FormDeleteMaintenanceViewModel();

  List<String> reasonItems = [
    "Dibatalkan oleh pelanggan",
    "Teknisi berhalangan pada hari tersebut",
    "Dijadwalkan ulang",
    "Teknisi/Pelanggan lupa",
    "Lainnya",
  ];

  String _selectedReason = "Dibatalkan oleh pelanggan.";
  String get selectedReason => _selectedReason;

  @override
  Future<void> initModel() async {}

  void setSelectedReason(String value) {
    _selectedReason = value;
    notifyListeners();
  }
}
