import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class FormFollowUpViewModel extends BaseViewModel {
  FormFollowUpViewModel({
    ProjectData? projectData,
    required DioService dioService,
    required SharedPreferencesService sharedPreferencesService,
    required GCloudService gCloudService,
    required RemoteConfigService remoteConfigService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _sharedPreferenceService = sharedPreferencesService,
        _projectData = projectData,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferenceService;
  final GCloudService _gCloudService;
  final RemoteConfigService _remoteConfigService;

  ProjectData? _projectData;
  ProjectData? get projectData => _projectData;

  //region Feature flag values
  bool _isGCloudStorageEnabled = false;
  //endregion

  // Filter related
  int _selectedHasilKonfirmasiOption = 0;
  int get selectedHasilKonfirmasiOption => _selectedHasilKonfirmasiOption;
  final List<FilterOption> _hasilKonfirmasiOption = [
    FilterOption("Loss", true),
    FilterOption("Win", false),
    FilterOption("Hot", false),
    FilterOption("In Progress", false),
  ];
  List<FilterOption> get hasilKonfirmasiOption => _hasilKonfirmasiOption;
  // End of filter related

  //region gallery
  final List<GalleryData> _galleryData = [];
  List<GalleryData> get galleryData => _galleryData;

  List<FollowUpFile> _uploadedFiles = [];
  List<FollowUpFile> get uploadedFiles => _uploadedFiles;
  //endregion

  //region next followup date
  List<DateTime> _selectedNextFollowUpDates = [
    DateTime.now().add(
      Duration(
        days: 14,
      ),
    ),
  ];
  List<DateTime> get selectedNextFollowUpDates => _selectedNextFollowUpDates;
  //endregion

  List<DateTime> _selectedDates = [
    DateTime.now(),
  ];
  List<DateTime> get selectedDates => _selectedDates;

  final noteController = TextEditingController();

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _isGCloudStorageEnabled =
        _remoteConfigService.isGCloudStorageEnabled ?? false;
    setBusy(false);
  }

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

  void setSelectedNextFollowUpDates(List<DateTime> value) {
    _selectedNextFollowUpDates = value;
    notifyListeners();
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<bool> _requestUpdateFollowUp() async {
    final response = await _apiService.requestCreateFollowUp(
      projectId: int.parse(projectData?.projectId ?? "0"),
      followUpResult: _selectedHasilKonfirmasiOption,
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
      note: noteController.text,
      documents: _uploadedFiles,
      // nextScheduleDate: DateTimeUtils.convertDateToString(
      //   date: _selectedDates.first,
      //   formatter: DateFormat(
      //     DateTimeUtils.DATE_FORMAT_3,
      //   ),
      // ),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> _saveGalleryToCloud() async {
    try {
      final currDateString = DateTimeUtils.convertDateToString(
        date: DateTime.now(),
        formatter: DateFormat(DateTimeUtils.DATE_FORMAT_3),
      );

      for (GalleryData gallery in galleryData) {
        File file = File(gallery.filepath);
        String ext = gallery.filepath.split('.').last;

        final response = await _gCloudService.save(
          '${_projectData?.projectId}_follow_up_data_$currDateString.$ext',
          file.readAsBytesSync(),
        );
        print("LINK GCLOUD: ${response?.downloadLink}");

        //Save the link that will be sent to api
        //We wont be used the downloadLink, because we only need to show the photo/ video to the user. No need to download it.
        _uploadedFiles.add(
          FollowUpFile(
            filePath:
                "${EnvConstants.baseGCloudPublicUrl}${_projectData?.projectId}_follow_up_data_${currDateString.replaceAll(' ', '%20').replaceAll(':', '%3A')}.$ext",
          ),
        );
        print("LINK UPLOADED SERVER: ${gallery.filepath}");
      }
    } catch (e) {
      _errorMsg = "$e";
    }
  }

  Future<bool> _requestUpdateFollowUpDummy() async {
    final response = await _apiService.requestCreateFollowUp(
      projectId: int.parse(_projectData?.projectId ?? "0"),
      followUpResult: _selectedHasilKonfirmasiOption,
      scheduleDate: DateTimeUtils.convertDateToString(
        date: _selectedDates.first,
        formatter: DateFormat(
          DateTimeUtils.DATE_FORMAT_3,
        ),
      ),
      note: noteController.text,
      documents: <FollowUpFile>[
        FollowUpFile(
          filePath:
              "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
        ),
      ],
      // nextScheduleDate: DateTimeUtils.convertDateToString(
      //   date: _selectedDates.first,
      //   formatter: DateFormat(
      //     DateTimeUtils.DATE_FORMAT_3,
      //   ),
      // ),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestSaveFollowUpData() async {
    _errorMsg = null;

    if (!_isGCloudStorageEnabled) {
      return await _requestUpdateFollowUpDummy();
    }

    await _saveGalleryToCloud();
    if (_errorMsg != null) return false;

    return await _requestUpdateFollowUp();
  }
}
