// import 'package:permission_handler/permission_handler.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestPermissions({
    required List<Permission> listPermission,
  }) async {
    var mapPermission = {
      for (var permission in listPermission) permission: PermissionStatus.denied
    };

    for (var permission in listPermission) {
      PermissionStatus status = await permission.status;
      mapPermission[permission] = status;
    }

    if (!mapPermission.containsValue(PermissionStatus.denied) &&
            !mapPermission.containsValue(PermissionStatus.permanentlyDenied) ||
        !mapPermission.containsValue(PermissionStatus.restricted)) return true;

    //check if there is any permanent denied
    if (mapPermission.containsValue(PermissionStatus.permanentlyDenied)) {
      openAppSettings();
      return false;
    }

    var needRequestAgain = mapPermission.keys
        .where((element) =>
            mapPermission[element] != PermissionStatus.granted ||
            mapPermission[element] != PermissionStatus.limited)
        .toList();
    Map<Permission, PermissionStatus> statuses =
        await needRequestAgain.request();
    return !statuses.values.contains(PermissionStatus.denied) &&
        !statuses.values.contains(PermissionStatus.permanentlyDenied) &&
        !statuses.values.contains(PermissionStatus.restricted);
  }

  static Future<bool> requestPermission(Permission permission) async {
    final currStatus = await permission.status;
    switch (currStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        return false;
      case PermissionStatus.denied:
      default:
        permission.request();
        return false;
    }
  }
}
