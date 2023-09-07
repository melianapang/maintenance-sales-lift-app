import 'package:json_annotation/json_annotation.dart';

part 'unit_dto.g.dart';

//region get all unit
@JsonSerializable()
class GetAllUnitResponse {
  GetAllUnitResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllUnitResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUnitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllUnitResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListUnitData data;
}

@JsonSerializable()
class ListUnitData {
  ListUnitData({
    required this.totalSize,
    required this.result,
  });

  factory ListUnitData.fromJson(Map<String, dynamic> json) =>
      _$ListUnitDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListUnitDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<UnitData> result;
}

@JsonSerializable()
class UnitData {
  UnitData({
    required this.unitId,
    required this.unitName,
    required this.unitLocation,
    this.projectId,
    this.projectName,
    required this.tipeUnit,
    required this.jenisUnit,
    required this.kapasitas,
    required this.speed,
    required this.totalLantai,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) =>
      _$UnitDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnitDataToJson(this);

  @JsonKey(name: "unit_id")
  final String unitId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "project_id")
  final String? projectId;

  @JsonKey(name: "project_name")
  final String? projectName;

  @JsonKey(name: "unit_type")
  final String tipeUnit;

  @JsonKey(name: "unit_kind")
  final String? jenisUnit;

  @JsonKey(name: "capacity")
  final String kapasitas;

  @JsonKey(name: "speed")
  final String speed;

  @JsonKey(name: "step_width")
  final String totalLantai;
}
//endregion

//region create unit
@JsonSerializable()
class CreateUnitRequest {
  CreateUnitRequest({
    required this.customerId,
    this.projectId,
    required this.unitName,
    required this.unitLocation,
    required this.tipeUnit,
    required this.jenisUnit,
    required this.kapasitas,
    required this.speed,
    required this.totalLantai,
    required this.firstMaintenanceDate,
  });

  factory CreateUnitRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUnitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUnitRequestToJson(this);

  @JsonKey(name: "customer_id")
  final int customerId;

  @JsonKey(name: "project_id")
  final int? projectId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "unit_type")
  final int tipeUnit;

  @JsonKey(name: "unit_kind")
  final int? jenisUnit;

  @JsonKey(name: "capacity")
  final double kapasitas;

  @JsonKey(name: "speed")
  final double speed;

  @JsonKey(name: "step_width")
  final double totalLantai;

  @JsonKey(name: "schedule_date")
  final String firstMaintenanceDate;
}

@JsonSerializable()
class CreateUnitResponse {
  CreateUnitResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateUnitResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUnitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUnitResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region update unit
@JsonSerializable()
class UpdateUnitRequest {
  UpdateUnitRequest({
    required this.customerId,
    required this.projectId,
    required this.unitName,
    required this.unitLocation,
    required this.tipeUnit,
    required this.jenisUnit,
    required this.kapasitas,
    required this.speed,
    required this.totalLantai,
  });

  factory UpdateUnitRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUnitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUnitRequestToJson(this);

  @JsonKey(name: "customer_id")
  final int customerId;

  @JsonKey(name: "project_id")
  final int projectId;

  @JsonKey(name: "unit_name")
  final String unitName;

  @JsonKey(name: "unit_location")
  final String unitLocation;

  @JsonKey(name: "unit_type")
  final int tipeUnit;

  @JsonKey(name: "unit_kind")
  final int? jenisUnit;

  @JsonKey(name: "capacity")
  final double kapasitas;

  @JsonKey(name: "speed")
  final double speed;

  @JsonKey(name: "step_width")
  final double totalLantai;
}

@JsonSerializable()
class UpdateUnitResponse {
  UpdateUnitResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UpdateUnitResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUnitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUnitResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}
//endregion

//region get unit detail
@JsonSerializable()
class UnitDetailResponse {
  UnitDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UnitDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$UnitDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnitDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final UnitData data;
}
//endregion