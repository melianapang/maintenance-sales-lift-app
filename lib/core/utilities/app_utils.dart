import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  static Future<bool> hasToUpdateApp({required String requiredVersion}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final extendedCurrVersion = _getExtendedVersionNumber(packageInfo.version);
    final extendedRequiredVersion = _getExtendedVersionNumber(requiredVersion);

    return extendedRequiredVersion > extendedCurrVersion;
  }

  static int _getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}
