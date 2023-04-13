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
