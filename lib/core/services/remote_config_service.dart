import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService();
  static const String _minVersionBuildNumberKey = 'min_version_build_number';
  static const String _latestVersionKey = 'latest_version';

  // feature flags
  static const String _gCloudStorage = 'gcloud_storage_ff';

  late FirebaseRemoteConfig _remoteConfig;

  void setRemoteConfig(FirebaseRemoteConfig remoteConfig) =>
      _remoteConfig = remoteConfig;

  Future<void> initialize() async {
    setRemoteConfig(FirebaseRemoteConfig.instance);
    // await _remoteConfig.setDefaults(await _getDefaults());

    await _fetchAndActivate();
  }

  Future<void> _fetchAndActivate() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  // String _generateVersionKey(String key) {
  //   return '${AppConstant.platform}_$key';
  // }

  // Future<Map<String, dynamic>> _getDefaults() async {
  //   final Map<String, dynamic> defaults = <String, dynamic>{};

  //   defaults.addAll(<String, dynamic>{
  //     _generateVersionKey(_minVersionKey): '1.0.0',
  //     _generateVersionKey(_latestVersionKey): '1.0.0',
  //   });

  //   return defaults;
  // }

  String? get appMinVersion => _remoteConfig.getString(
        _minVersionBuildNumberKey,
      );

  // String? get appLatestVersion => _remoteConfig.getString(
  //       _generateVersionKey(_latestVersionKey),
  //     );

  bool? get isGCloudStorageEnabled => _remoteConfig.getBool(
        _gCloudStorage,
      );
}
