import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:ota_update/ota_update.dart';

class UpdateApkViewModel extends BaseViewModel {
  UpdateApkViewModel();

  bool? _isUpdatingApk;
  bool? get isUpdatingApk => _isUpdatingApk;

  OtaEvent? _downloadApkEvent;
  OtaEvent? get downloadApkEvent => _downloadApkEvent;

  @override
  Future<void> initModel() async {
    bool isAllowedToUpdate = await _checkPermissionsToAllowedUpdate();
    if (!isAllowedToUpdate) {
      await _requestPermissionToDownloadApk();
    }
  }

  void updateApk() async {
    if (_isUpdatingApk == true) return;

    bool isAllowedToUpdate = await _checkPermissionsToAllowedUpdate();
    if (!isAllowedToUpdate) {
      bool isPermissionGranted = await _requestPermissionToDownloadApk();
      if (!isPermissionGranted) {
        return;
      }
    }

    setBusy(true);
    _isUpdatingApk = true;
    _downloadApkEvent = null;
    tryOtaUpdate();

    setBusy(false);
  }

  Future<bool> _checkPermissionsToAllowedUpdate() async {
    return await PermissionUtils.requestPermissions(listPermission: [
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<bool> _requestPermissionToDownloadApk() async {
    return await PermissionUtils.requestPermissions(listPermission: [
      Permission.notification,
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<void> tryOtaUpdate() async {
    try {
      print('ABI Platform: ${await OtaUpdate().getAbi()}');
      OtaUpdate()
          .execute(
        "${EnvConstants.baseURL}/api/0/Apk/download_apk/",
        destinationFilename: 'rejo_jaya_sakti.apk',
      )
          .listen(
        (OtaEvent event) {
          _downloadApkEvent = event;

          switch (event.status) {
            case OtaStatus.INSTALLING:
            case OtaStatus.DOWNLOADING:
              _isUpdatingApk = true;
              break;
            case OtaStatus.ALREADY_RUNNING_ERROR:
            case OtaStatus.CHECKSUM_ERROR:
            case OtaStatus.DOWNLOAD_ERROR:
            case OtaStatus.INTERNAL_ERROR:
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
              _isUpdatingApk = false;
              break;
          }

          print(
              "APK DOWNLOADER: ${_downloadApkEvent?.status} ${_downloadApkEvent?.value}");
          notifyListeners();
        },
      );
    } catch (e) {
      _isUpdatingApk = false;
      _downloadApkEvent = OtaEvent(OtaStatus.DOWNLOAD_ERROR, "Gagal");
      print('Failed to make OTA update. Details: $e');
    }
  }
}
