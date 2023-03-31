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
  MaintenanceData(
      {required this.maintenanceId,
      required this.userId,
      required this.unitId,
      required this.pic,
      required this.latitude,
      required this.longitude,
      required this.maintenanceResult,
      required this.startMaintenance,
      required this.endMaintenance,
      required this.scheduleDate,
      required this.status,
      required this.note,
      required this.customerId,
      required this.unitName,
      required this.unitLocation,
      required this.statusDeleted});

  factory MaintenanceData.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceDataToJson(this);

  @JsonKey(name: "maintenance_id")
  final String maintenanceId;

  @JsonKey(name: "user_id")
  final String userId;

  @JsonKey(name: "unit_id")
  final String unitId;

  @JsonKey(name: "pic")
  final String pic;

  @JsonKey(name: "latitude")
  final String latitude;

  @JsonKey(name: "longitude")
  final String longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "start_maintenance")
  final String startMaintenance;

  @JsonKey(name: "end_maintenance")
  final String endMaintenance;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "status")
  final String status;

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "status_deleted")
  final String statusDeleted;
}

@JsonSerializable()
class UpdateMaintenanceRequest {
  UpdateMaintenanceRequest({
    required this.userId,
    required this.unitId,
    required this.pic,
    required this.latitude,
    required this.longitude,
    required this.maintenanceResult,
    required this.startMaintenance,
    required this.endMaintenance,
    required this.scheduleData,
    required this.status,
    required this.note,
  });

  factory UpdateMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMaintenanceRequestToJson(this);

  @JsonKey(name: "user_id")
  final int userId;

  @JsonKey(name: "unit_id")
  final int unitId;

  @JsonKey(name: "pic")
  final String pic;

  @JsonKey(name: "latitude")
  final double latitude;

  @JsonKey(name: "longitude")
  final double longitude;

  @JsonKey(name: "maintenance_result")
  final String maintenanceResult;

  @JsonKey(name: "start_maintenance")
  final String startMaintenance;

  @JsonKey(name: "end_maintenance")
  final int endMaintenance;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_data")
  final String scheduleData;

  @JsonKey(name: "status")
  final int status;
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
