import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormFollowUpViewModel extends BaseViewModel {
  FormFollowUpViewModel();

  // Filter related
  int _selectedHasilKonfirmasiOption = 0;
  int get selectedHasilKonfirmasiOption => _selectedHasilKonfirmasiOption;
  final List<FilterOption> _hasilKonfirmasiOption = [
    FilterOption("Konfirmasi Pertama", true),
    FilterOption("Konfirmasi Kedua", false),
    FilterOption("Konfirmasi Ketiga", false),
    FilterOption("Negosiasi", false),
    FilterOption("Instalasi", false),
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get hasilKonfirmasiOption => _hasilKonfirmasiOption;
  // End of filter related

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  @override
  Future<void> initModel() async {}

  void setHasilKonfirmasi(int index) {
    _selectedHasilKonfirmasiOption = index;
    for (int i = 0; i < _hasilKonfirmasiOption.length; i++) {
      if (i == _selectedHasilKonfirmasiOption) {
        _hasilKonfirmasiOption[i].isSelected = true;
        continue;
      }
      _hasilKonfirmasiOption[i].isSelected = false;
    }
    notifyListeners();
  }

  void setSelectedDates(List<DateTime> value) {
    _selectedDates = value;
    notifyListeners();
  }
}
