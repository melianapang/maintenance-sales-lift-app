import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class UploadDocumentViewModel extends BaseViewModel {
  UploadDocumentViewModel();

  int _selectedTipeDokumentOption = 0;
  int get selectedTipeDokumentOption => _selectedTipeDokumentOption;
  final List<FilterOption> _tipeDokumentOption = [
    FilterOption("Purchase Order", true),
    FilterOption("Quotation", false),
    FilterOption("Dokumen Perjanjian Kerja Sama", false),
  ];
  List<FilterOption> get tipeDokumentOption => _tipeDokumentOption;

  @override
  Future<void> initModel() async {}

  void setTipeDokumen({
    required int selectedMenu,
  }) {
    _selectedTipeDokumentOption = selectedMenu;
    for (int i = 0; i < _tipeDokumentOption.length; i++) {
      if (i == selectedMenu) {
        _tipeDokumentOption[i].isSelected = true;
        continue;
      }
      _tipeDokumentOption[i].isSelected = false;
    }

    notifyListeners();
  }
}
