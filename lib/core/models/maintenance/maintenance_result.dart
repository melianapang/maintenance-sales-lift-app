import 'package:json_annotation/json_annotation.dart';

enum MaintenanceStatus {
  DELETED,
  NOT_MAINTENANCED,
  FAILED,
  SUCCESS,
}

MaintenanceStatus mappingStringtoMaintenanceStatus(String value) {
  switch (value) {
    case "0":
      return MaintenanceStatus.NOT_MAINTENANCED;
    case "-1":
      return MaintenanceStatus.DELETED;
    case "1":
      return MaintenanceStatus.FAILED;
    case "2":
      return MaintenanceStatus.SUCCESS;
    default:
      return MaintenanceStatus.NOT_MAINTENANCED;
  }
}

String mappingMaintenanceStatusToString(MaintenanceStatus value) {
  switch (value) {
    case MaintenanceStatus.NOT_MAINTENANCED:
      return "0";
    case MaintenanceStatus.DELETED:
      return "-1";
    case MaintenanceStatus.FAILED:
      return "1";
    case MaintenanceStatus.SUCCESS:
      return "2";
    default:
      return "0";
  }
}

String mappingStringNumerictoString(String value) {
  switch (value) {
    case "0":
      return "Belum Pemeliharaan";
    case "-1":
      return "Data Pemeliharaan Dihapus";
    case "1":
      return "Batal/Gagal";
    case "2":
      return "Berhasil";
    default:
      return "Belum Pemeliharaan";
  }
}

enum MaintenanceDataType {
  @JsonValue('CUST')
  customer,
  @JsonValue('PROJ')
  project,
}

extension PartOrKomponenTypeExt on MaintenanceDataType {
  static const Map<MaintenanceDataType, String> labels =
      <MaintenanceDataType, String>{
    MaintenanceDataType.customer: "Customer",
    MaintenanceDataType.project: "Project",
  };

  String get label => labels[this]!;

  static const Map<MaintenanceDataType, String> localeKeys =
      <MaintenanceDataType, String>{
    MaintenanceDataType.customer: "CUST",
    MaintenanceDataType.project: "PROJ",
  };

  String get localeKey => localeKeys[this]!;
}
