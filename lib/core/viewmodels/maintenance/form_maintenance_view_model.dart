import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/location_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormMaintenanceViewModel extends BaseViewModel {
  FormMaintenanceViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
    required SharedPreferencesService sharedPreferencesService,
    required GCloudService gCloudService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _maintenanceData = maintenanceData,
        _sharedPreferenceService = sharedPreferencesService,
        _gCloudService = gCloudService;

  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferenceService;
  final GCloudService _gCloudService;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  GalleryData? gallery;

  final noteController = TextEditingController();

  // Filter related
  int _selectedHasilMaintenanceOption = 0;
  int get selectedHasilMaintenanceOption => _selectedHasilMaintenanceOption;
  final List<FilterOption> _hasilMaintenanceOption = [
    FilterOption("Batal/Gagal", true),
    FilterOption("Berhasil", false),
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

  //region gallery
  final List<GalleryData> _compressedFiles = [];
  List<GalleryData> get compressedFiles => _compressedFiles;

  List<MaintenanceFile> _uploadedFiles = [];
  List<MaintenanceFile> get uploadedFiles => _uploadedFiles;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

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

  void setSelectedNextMaintenanceDates(List<DateTime> value) {
    _selectedNextMaintenanceDates = value;
    notifyListeners();
  }

  Future<bool> _requestUpdateMaintenanceData() async {
    Position? position = await LocationUtils.getCurrentPosition();
    if (position == null) {
      _errorMsg = "Tolong ijinkan aplikasi untuk mengakses lokasi anda.";
      return false;
    }

    String userId = await _sharedPreferenceService.get(SharedPrefKeys.userId);

    final response = await _apiService.requestUpdateMaintenace(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
      unitId: int.parse(_maintenanceData?.unitId ?? "0"),
      userId: int.parse(userId),
      latitude: position.latitude,
      longitude: position.longitude,
      maintenanceResult: _selectedHasilMaintenanceOption + 1,
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedNextMaintenanceDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
      note: noteController.text,
      maintenanceFiles: _uploadedFiles,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> _saveGalleryToCloud() async {
    try {
      _uploadedFiles = [];
      final currDateString = DateTimeUtils.convertDateToString(
        date: DateTime.now(),
        formatter: DateFormat(DateTimeUtils.DATE_FORMAT_3),
      );

      for (GalleryData gallery in _compressedFiles) {
        File file = File(gallery.filepath);

        //filePath = maintenanceId + 'maintenance_data' + converted current date time + file ke berapa + extension (jpg/jpeg)
        String ext = gallery.filepath.split('.').last;
        final nFile = _compressedFiles.indexOf(gallery) > 0
            ? "_${_compressedFiles.indexOf(gallery)}"
            : "";

        // Upload to Google cloud
        final response = await _gCloudService.save(
          '${maintenanceData?.maintenanceId}_maintenance_data_$currDateString$nFile.$ext',
          file.readAsBytesSync(),
        );
        print("LINK GCLOUD: ${response?.downloadLink}");

        //Save the link that will be sent to api
        _uploadedFiles.add(
          MaintenanceFile(
            filePath:
                "${EnvConstants.baseGCloudPublicUrl}${maintenanceData?.maintenanceId}_maintenance_data_${currDateString.replaceAll(' ', '%20').replaceAll(':', '%3A')}$nFile.$ext",
            fileType: gallery.galleryType == GalleryType.PHOTO ? "1" : "2",
          ),
        );
        print("LINK UPLOADED SERVER: ${gallery.filepath}");
      }
    } catch (e) {
      _errorMsg = "$e";
    }
  }

  Future<bool> requestSaveMaintenanceData() async {
    await _saveGalleryToCloud();
    if (_errorMsg != null) return false;

    return await _requestUpdateMaintenanceData();
  }
}
