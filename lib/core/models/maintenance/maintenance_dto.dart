import 'package:json_annotation/json_annotation.dart';

part 'maintenance_dto.g.dart';

@JsonSerializable()
class GetAllMaintenanceResponse {
  GetAllMaintenanceResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllMaintenanceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllMaintenanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllMaintenanceResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListMaintenanceData data;
}

@JsonSerializable()
class ListMaintenanceData {
  ListMaintenanceData({
    required this.result,
  });

  factory ListMaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$ListMaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListMaintenanceDataToJson(this);

  @JsonKey(name: "result")
  final List<MaintenanceData> result;
}

@JsonSerializable()
class MaintenanceData {
  MaintenanceData({
    required this.maintenanceId,
    required this.userName,
    required this.phoneNumber,
    required this.customerName,
    required this.companyName,
    required this.projectId,
    required this.projectName,
    required this.unitId,
    required this.unitName,
    required this.unitLocation,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.updateMaintenanceDateTime,
    required this.note,
    required this.maintenanceFiles,
    required this.lastMaintenanceResult,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceDataToJson(this);

  @JsonKey(name: "maintenance_id")
  final String maintenanceId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "latitude")
  final String? latitude;

  @JsonKey(name: "longitude")
  final String? longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "update_maintenance_datetime")
  final String? updateMaintenanceDateTime;

  @JsonKey(name: "unit_id")
  final String unitId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "last_maintenance_result")
  final String? lastMaintenanceResult;

  @JsonKey(name: "maintenance_file")
  final List<MaintenanceFile>? maintenanceFiles;
}

@JsonSerializable()
class UpdateMaintenanceRequest {
  UpdateMaintenanceRequest({
    required this.unitId,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.note,
    required this.maintenanceFiles,
    required this.lastMaintenanceResult,
  });

  factory UpdateMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMaintenanceRequestToJson(this);

  @JsonKey(name: "unit_id")
  final int unitId;

  @JsonKey(name: "latitude")
  final double? latitude;

  @JsonKey(name: "longitude")
  final double? longitude;

  @JsonKey(name: "maintenance_result")
  final int maintenanceResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "last_maintenance_result")
  final String? lastMaintenanceResult;

  @JsonKey(name: "maintenance_file")
  final List<MaintenanceFile>? maintenanceFiles;
}

//region document data
@JsonSerializable()
class MaintenanceFile {
  MaintenanceFile({
    required this.filePath,
    required this.thumbnailPath,
    required this.fileType,
  });

  factory MaintenanceFile.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFileFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceFileToJson(this);

  @JsonKey(name: "file_path")
  final String filePath;

  @JsonKey(name: "thumbnail_path")
  final String? thumbnailPath;

  @JsonKey(name: "file_type")
  final String fileType;
}
//endregion

@JsonSerializable()
class UpdateMaintenanceResponse {
  UpdateMaintenanceResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UpdateMaintenanceResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateMaintenanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMaintenanceResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}

//region detail maintenance
@JsonSerializable()
class MaintenanceDetailResponse {
  MaintenanceDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory MaintenanceDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final MaintenanceData data;
}

@JsonSerializable()
class DetailMaintenanceData {
  DetailMaintenanceData({
    required this.maintenanceId,
    required this.userName,
    required this.phoneNumber,
    required this.customerName,
    required this.unitName,
    required this.unitLocation,
    required this.projectId,
    required this.projectName,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.updateMaintenanceDateTime,
    required this.note,
    required this.maintenanceFiles,
  });

  factory DetailMaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$DetailMaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailMaintenanceDataToJson(this);

  @JsonKey(name: "maintenance_id")
  final String maintenanceId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "latitude")
  final String? latitude;

  @JsonKey(name: "longitude")
  final String? longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "update_maintenance_datetime")
  final String? updateMaintenanceDateTime;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "maintenance_files")
  final List<MaintenanceData>? maintenanceFiles;
}
//endregion

//get history maintenance
@JsonSerializable()
class GetHistoryMaintenanceResponse {
  GetHistoryMaintenanceResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetHistoryMaintenanceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetHistoryMaintenanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetHistoryMaintenanceResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListHistoryMaintenane data;
}

@JsonSerializable()
class ListHistoryMaintenane {
  ListHistoryMaintenane({
    required this.result,
  });

  factory ListHistoryMaintenane.fromJson(Map<String, dynamic> json) =>
      _$ListHistoryMaintenaneFromJson(json);

  Map<String, dynamic> toJson() => _$ListHistoryMaintenaneToJson(this);

  @JsonKey(name: "result")
  final List<HistoryMaintenanceData> result;
}

@JsonSerializable()
class HistoryMaintenanceData {
  HistoryMaintenanceData({
    required this.maintenanceId,
    required this.userName,
    required this.phoneNumber,
    required this.customerName,
    required this.companyName,
    required this.unitId,
    required this.unitName,
    required this.unitLocation,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.updateMaintenanceDateTime,
    required this.note,
    required this.maintenanceFiles,
  });

  factory HistoryMaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$HistoryMaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryMaintenanceDataToJson(this);
  @JsonKey(name: "maintenance_id")
  final String maintenanceId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String companyName;

  @JsonKey(name: "unit_id")
  final String unitId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "latitude")
  final String? latitude;

  @JsonKey(name: "longitude")
  final String? longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "update_maintenance_datetime")
  final String updateMaintenanceDateTime;

  @JsonKey(name: "maintenance_file")
  final List<MaintenanceFile>? maintenanceFiles;
}
//endregion

//region create maintenance
@JsonSerializable()
class CreateMaintenanceRequest {
  CreateMaintenanceRequest({
    required this.unitId,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.note,
  });

  factory CreateMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMaintenanceRequestToJson(this);

  @JsonKey(name: "unit_id")
  final int unitId;

  @JsonKey(name: "latitude")
  final double? latitude;

  @JsonKey(name: "longitude")
  final double? longitude;

  @JsonKey(name: "maintenance_result")
  final int maintenanceResult;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "note")
  final String note;
}

@JsonSerializable()
class CreateMaintenanceResponse {
  CreateMaintenanceResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CreateMaintenanceResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateMaintenanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMaintenanceResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final CreatedMaintenanceIdData data;
}

@JsonSerializable()
class CreatedMaintenanceIdData {
  CreatedMaintenanceIdData({
    required this.createdMaintenanceId,
  });

  factory CreatedMaintenanceIdData.fromJson(Map<String, dynamic> json) =>
      _$CreatedMaintenanceIdDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedMaintenanceIdDataToJson(this);

  @JsonKey(name: "created_maintenance_id")
  final bool createdMaintenanceId;
}
//endregion

//region delete maintenance
@JsonSerializable()
class DeleteMaintenanceRequest {
  DeleteMaintenanceRequest({
    required this.noteDeleted,
  });

  factory DeleteMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMaintenanceRequestToJson(this);

  @JsonKey(name: "note_deleted")
  final String noteDeleted;
}

@JsonSerializable()
class DeleteMaintenanceResponse {
  DeleteMaintenanceResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteMaintenanceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteMaintenanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMaintenanceResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region change maintenance date
@JsonSerializable()
class ChangeMaintenanceDateRequest {
  ChangeMaintenanceDateRequest({
    required this.scheduleDate,
  });

  factory ChangeMaintenanceDateRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangeMaintenanceDateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeMaintenanceDateRequestToJson(this);

  @JsonKey(name: "schedule_date")
  final String scheduleDate;
}

@JsonSerializable()
class ChangeMaintenanceDateResponse {
  ChangeMaintenanceDateResponse({
    required this.isSuccess,
    required this.message,
  });

  factory ChangeMaintenanceDateResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangeMaintenanceDateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeMaintenanceDateResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion