import 'dart:convert';

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
    required this.projectName,
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

  @JsonKey(name: "project_name")
  final String projectName;
}
//endregion