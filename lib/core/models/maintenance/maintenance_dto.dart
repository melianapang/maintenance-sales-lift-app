import 'dart:ffi';
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
    required this.unitId,
    required this.unitName,
    required this.unitLocation,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.note,
    required this.maintenanceFiles,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceDataToJson(this);

  @JsonKey(name: "maintenance_id")
  final String maintenanceId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

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

  @JsonKey(name: "unit_id")
  final String unitId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "maintenance_file")
  final List<MaintenanceFileData> maintenanceFiles;
}

@JsonSerializable()
class MaintenanceFileData {
  MaintenanceFileData({
    required this.filePath,
    required this.fileType,
    required this.createdAt,
  });

  factory MaintenanceFileData.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFileDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceFileDataToJson(this);

  @JsonKey(name: "file_path")
  final String filePath;

  @JsonKey(name: "file_type")
  final String fileType;

  @JsonKey(name: "created_at")
  final String? createdAt;
}

@JsonSerializable()
class UpdateMaintenanceRequest {
  UpdateMaintenanceRequest({
    required this.userId,
    required this.unitId,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
    required this.note,
  });

  factory UpdateMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMaintenanceRequestToJson(this);

  @JsonKey(name: "user_id")
  final int userId;

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
}

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
  final DetailMaintenanceData data;
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
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.scheduleDate,
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
  final String latitude;

  @JsonKey(name: "longitude")
  final String longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "maintenance_files")
  final List<MaintenanceData>? maintenanceFiles;
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
  final double latitude;

  @JsonKey(name: "longitude")
  final double longitude;

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