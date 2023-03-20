import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListCustomerViewModel extends BaseViewModel {
  ListCustomerViewModel();

  // Filter related
  int _selectedTipePelangganOption = 0;
  int get selectedTipePelangganOption => _selectedTipePelangganOption;
  final List<FilterOption> _tipePelangganOptions = [
    FilterOption("Perorangan", true),
    FilterOption("Perusahaan", false),
  ];
  List<FilterOption> get tipePelangganOptions => _tipePelangganOptions;

  int _selectedSumberDataOption = 0;
  int get selectedSumberDataOption => _selectedSumberDataOption;
  final List<FilterOption> _sumberDataOptions = [
    FilterOption("Lead", true),
    FilterOption("Non-Leads", false),
  ];
  List<FilterOption> get sumberDataOptions => _sumberDataOptions;

  int _selectedTahapKonfirmasiOption = 0;
  int get selectedTahapKonfirmasiOption => _selectedTahapKonfirmasiOption;
  final List<FilterOption> _tahapKonfirmasiOptions = [
    FilterOption("Butuh Konfirmasi", true),
    FilterOption("Konfirmasi kedua", false),
    FilterOption("Konfirmasi ketiga", false),
    FilterOption("Nego", false),
    FilterOption("Instalasi", false),
    FilterOption("Selesai", false),
    FilterOption("Batal", false),
  ];
  List<FilterOption> get tahapKonfirmasiOptions => _tahapKonfirmasiOptions;

  int _selectedSortOption = 0;
  int get selectedSortOption => _selectedSortOption;
  final List<FilterOption> _sortOptions = [
    FilterOption("Ascending", true),
    FilterOption("Descending", false),
  ];
  List<FilterOption> get sortOptions => _sortOptions;
  // End of filter related

  @override
  Future<void> initModel() async {}

  void terapkanFilter({
    required int selectedPelanggan,
    required int selectedSumberData,
    required int selectedTahapKonfirmasi,
    required int selectedSort,
  }) {
    _selectedTipePelangganOption = selectedPelanggan;
    _selectedSumberDataOption = selectedSumberData;
    _selectedTahapKonfirmasiOption = selectedTahapKonfirmasi;
    _selectedSortOption = selectedSort;
    for (int i = 0; i < _tipePelangganOptions.length; i++) {
      if (i == selectedPelanggan) {
        _tipePelangganOptions[i].isSelected = true;
        continue;
      }
      _tipePelangganOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sumberDataOptions.length; i++) {
      if (i == selectedSumberData) {
        _sumberDataOptions[i].isSelected = true;
        continue;
      }
      _sumberDataOptions[i].isSelected = false;
    }

    for (int i = 0; i < _tahapKonfirmasiOptions.length; i++) {
      if (i == selectedTahapKonfirmasi) {
        _tahapKonfirmasiOptions[i].isSelected = true;
        continue;
      }
      _tahapKonfirmasiOptions[i].isSelected = false;
    }

    for (int i = 0; i < _sortOptions.length; i++) {
      if (i == selectedSort) {
        _sortOptions[i].isSelected = true;
        continue;
      }
      _sortOptions[i].isSelected = false;
    }
    notifyListeners();
  }
}
