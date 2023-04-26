import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstants {
  static EnvironmentEnum _getEnvEnum(String environment) =>
      envMapping[environment] ?? EnvironmentEnum.dev;

  static EnvironmentEnum get env {
    final env = dotenv.env['ENV'];
    return _getEnvEnum(env ?? '');
  }

  static String get baseURL {
    return dotenv.env['BASE_URL'] ?? '';
  }

  static String get baseGCloudPublicUrl {
    return dotenv.env['BASE_URL_GCLOUD'] ?? '';
  }
}

enum EnvironmentEnum {
  dev,
  staging,
  production,
}

extension EnvironmentEnumExtension on EnvironmentEnum {
  static const Map<EnvironmentEnum, String> values = <EnvironmentEnum, String>{
    EnvironmentEnum.dev: 'dev',
    EnvironmentEnum.staging: 'staging',
    EnvironmentEnum.production: 'production',
  };

  String get value => values[this] ?? '';
}

Map<String, EnvironmentEnum> envMapping = <String, EnvironmentEnum>{
  EnvironmentEnum.dev.value: EnvironmentEnum.dev,
  EnvironmentEnum.staging.value: EnvironmentEnum.staging,
  EnvironmentEnum.production.value: EnvironmentEnum.production,
};
