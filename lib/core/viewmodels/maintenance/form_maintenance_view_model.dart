import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/location_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormMaintenanceViewModel extends BaseViewModel {
  FormMaintenanceViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
    required GCloudService gCloudService,
    required RemoteConfigService remoteConfigService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _maintenanceData = maintenanceData,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final ApiService _apiService;
  final GCloudService _gCloudService;
  final RemoteConfigService _remoteConfigService;

  int? _newMaintenanceId;
  int? get newMaintenanceId => _newMaintenanceId;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  GalleryData? gallery;

  //region Feature flag values
  bool _isGCloudStorageEnabled = false;
  //endregion

  final noteController = TextEditingController();

  // Filter related
  int _selectedHasilMaintenanceOption = 1;
  int get selectedHasilMaintenanceOption => _selectedHasilMaintenanceOption;
  final List<FilterOption> _hasilMaintenanceOption = [
    FilterOption("Batal/Gagal", false),
    FilterOption("Berhasil", true),
  ];
  List<FilterOption> get hasilMaintenanceOption => _hasilMaintenanceOption;
  // End of filter related

  bool get isEdit => true;

  //region next maintenance date
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
  //endregion

  //region gallery
  final List<GalleryData> _compressedFiles = [];
  List<GalleryData> get compressedFiles => _compressedFiles;

  List<MaintenanceFile> _uploadedFiles = [];
  List<MaintenanceFile> get uploadedFiles => _uploadedFiles;

  //max 1 data video
  bool get isReachingMaxTotalVideoData => getVideosData().isNotEmpty;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _setInitNextMaintenanceDate();
    _isGCloudStorageEnabled =
        _remoteConfigService.isGCloudStorageEnabled ?? false;
    setBusy(false);
  }

  void _setInitNextMaintenanceDate() {
    if (_maintenanceData?.scheduleDate != null ||
        _maintenanceData?.scheduleDate.isNotEmpty == true) {
      setSelectedNextMaintenanceDates([
        DateTimeUtils.convertStringToDate(
                formattedDateString: _maintenanceData!.scheduleDate)
            .add(const Duration(days: 7))
      ]);
    }
  }

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

    if (value.galleryType == GalleryType.VIDEO) {
      //to update data isReachingMaxTotalVideoData
      notifyListeners();
    }
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

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void _checkNewMaintenanceDate() {
    if (maintenanceData?.scheduleDate == null) return;

    DateTime currFollowUpDate = DateTimeUtils.convertStringToDate(
        formattedDateString: maintenanceData?.scheduleDate ?? "");
    if (_selectedNextMaintenanceDates.first.isBefore(currFollowUpDate)) {
      _errorMsg =
          "Tanggal pemeliharaan selanjutnya harus setelah tanggal pemeliharaan sekarang";
    }
  }

  Future<bool> _requestUpdateMaintenanceData() async {
    Position? position = await LocationUtils.getCurrentPosition();
    if (position == null) {
      _errorMsg = "Tolong ijinkan aplikasi untuk mengakses lokasi anda.";
      return false;
    }

    final response = await _apiService.requestUpdateMaintenace(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
      unitId: int.parse(_maintenanceData?.unitId ?? "0"),
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
      lastMaintenanceResult: (_selectedHasilMaintenanceOption + 1).toString(),
    );

    if (response.isRight) {
      _newMaintenanceId = response.right;
      setBusy(false);
      return true;
    }

    _errorMsg = response.left.message;
    setBusy(false);
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
          '${maintenanceData?.maintenanceId}_maintenance_data_${currDateString}_$nFile.$ext',
          file.readAsBytesSync(),
        );
        print("LINK GCLOUD: ${response?.downloadLink}");

        if (gallery.galleryType == GalleryType.VIDEO) {
          File thumbnailFile = File(gallery.thumbnailPath ?? "");
          // Upload to Google cloud for thumbnail video
          final response = await _gCloudService.save(
            '${maintenanceData?.maintenanceId}_maintenance_data_${currDateString}_${nFile}_thumbnail.jpg',
            thumbnailFile.readAsBytesSync(),
          );
          print("LINK GCLOUD THUMBNAIL VIDEO: ${response?.downloadLink}");
        }

        //Save the link that will be sent to api
        //We wont be used the downloadLink, because we only need to show the photo/ video to the user. No need to download it.
        final gCloudFileName =
            "${EnvConstants.baseGCloudPublicUrl}${maintenanceData?.maintenanceId}_maintenance_data_${currDateString.replaceAll(' ', '%20').replaceAll(':', '%3A')}_$nFile";

        _uploadedFiles.add(
          MaintenanceFile(
            filePath: "$gCloudFileName.$ext",
            thumbnailPath: gallery.galleryType == GalleryType.PHOTO
                ? ""
                : "${gCloudFileName}_thumbnail.jpg",
            fileType: gallery.galleryType == GalleryType.PHOTO ? "1" : "2",
          ),
        );
        print("LINK UPLOADED SERVER: ${gallery.filepath}");
      }
    } catch (e) {
      _errorMsg = "$e";
    }
  }

  Future<bool> _requestUpdateMaintenanceDataDummy() async {
    Position? position = await LocationUtils.getCurrentPosition();
    if (position == null) {
      _errorMsg = "Tolong ijinkan aplikasi untuk mengakses lokasi anda.";
      return false;
    }

    final response = await _apiService.requestUpdateMaintenace(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
      unitId: int.parse(_maintenanceData?.unitId ?? "0"),
      latitude: position.latitude,
      longitude: position.longitude,
      maintenanceResult: _selectedHasilMaintenanceOption + 1,
      lastMaintenanceResult: (_selectedHasilMaintenanceOption + 1).toString(),
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedNextMaintenanceDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
      note: noteController.text,
      maintenanceFiles: <MaintenanceFile>[
        //photo
        MaintenanceFile(
          filePath:
              "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
          thumbnailPath: "",
          fileType: "1",
        ),
        //photo
        MaintenanceFile(
          filePath:
              "https://www.rollingstone.com/wp-content/uploads/2019/12/TaylorSwiftTimIngham.jpg?w=1581&h=1054&crop=1",
          thumbnailPath: "",
          fileType: "1",
        ),
        //photo
        MaintenanceFile(
          filePath:
              "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
          thumbnailPath: "",
          fileType: "1",
        ),
        //photo
        MaintenanceFile(
          filePath:
              "https://i.guim.co.uk/img/media/a48e88b98455a5b118d3c1d34870a1d3aaa1b5c6/0_41_3322_1994/master/3322.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=b95f25e4e31f132166006345fd87b5ae",
          thumbnailPath: "",
          fileType: "1",
        ),
        //video
        MaintenanceFile(
          filePath:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          thumbnailPath:
              "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
          fileType: "2",
        ),
      ],
    );

    if (response.isRight) {
      setBusy(false);
      return true;
    }

    _errorMsg = response.left.message;
    setBusy(false);
    return false;
  }

  Future<bool> requestSaveMaintenanceData() async {
    setBusy(true);
    _errorMsg = null;

    if (!_isGCloudStorageEnabled) {
      return await _requestUpdateMaintenanceDataDummy();
    }

    _checkNewMaintenanceDate();
    if (_errorMsg != null) {
      setBusy(false);
      return false;
    }

    await _saveGalleryToCloud();
    if (_errorMsg != null) {
      setBusy(false);
      return false;
    }

    return await _requestUpdateMaintenanceData();
  }

  void sendDataBack(BuildContext context) {
    if (_newMaintenanceId == null) return;

    Navigator.pop(
      context,
      _newMaintenanceId,
    );
  }
}
