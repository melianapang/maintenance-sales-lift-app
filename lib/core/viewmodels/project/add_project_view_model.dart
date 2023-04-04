import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class AddProjectViewModel extends BaseViewModel {
  AddProjectViewModel();

  List<PicData> _listPic = [];
  List<PicData> get listPic => _listPic;

  int _selectedKeperluanProyekOption = 0;
  int get selectedKeperluanProyekOption => _selectedKeperluanProyekOption;
  final List<FilterOption> _keperluanProyekOptions = [
    FilterOption("Lift", true),
    FilterOption("Elevator", false),
    FilterOption("Lift dan Elevator", false),
    FilterOption("Lainnya", false),
  ];
  List<FilterOption> get keperluanProyekOptions => _keperluanProyekOptions;

  @override
  Future<void> initModel() async {}

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
}
