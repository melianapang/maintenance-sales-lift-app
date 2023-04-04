import 'dart:io';

import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
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

  List<DateTime> _selectedNextMaintenanceDates = [
    DateTime.now().add(
      Duration(
        days: 7,
      ),
    ),
  ];
  List<DateTime> get selectedNextMaintenanceDates =>
      _selectedNextMaintenanceDates;

  final List<GalleryData> _compressedFiles = [];
  List<GalleryData> get compressedFiles => _compressedFiles;

  @override
  Future<void> initModel() async {}

  List<GalleryData> getPhotosData() {
    return _compressedFiles
        .where((element) => element.galleryType == GalleryType.PHOTO)
        .toList();
  }

  List<GalleryData> getVideosData() {
    return _compressedFiles
        .where((element) => element.galleryType == GalleryType.VIDEO)
        .toList();
  }

  void addCompressedFile(GalleryData value) {
    _compressedFiles.add(value);
  }

  void removeCompressedFile(GalleryData data) {
    _compressedFiles.removeWhere((item) => item == data);
  }

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

  void setSelectedNextMaintenanceDates(List<DateTime> value) {
    _selectedNextMaintenanceDates = value;
    notifyListeners();
  }
}
