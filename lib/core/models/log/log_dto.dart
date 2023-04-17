import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'log_dto.g.dart';

//region get all log
@JsonSerializable()
class GetAllLogResponse {
  GetAllLogResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllLogResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllLogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllLogResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListLogData data;
}

@JsonSerializable()
class ListLogData {
  ListLogData({
    required this.totalSize,
    required this.result,
  });

  factory ListLogData.fromJson(Map<String, dynamic> json) =>
      _$ListLogDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListLogDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<LogData> result;
}

@JsonSerializable()
class LogData {
  LogData({
    required this.logId,
    required this.userName,
    required this.createdAt,
    required this.tableName,
    required this.moduleName,
    required this.contentsNew,
    required this.contentsOld,
  });

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  @JsonKey(name: "log_id")
  final String logId;

  @JsonKey(name: "name")
  final String userName;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "table_name")
  final String tableName;

  @JsonKey(name: "module_name")
  final String moduleName;

  @JsonKey(name: "contents_new")
  final Map<String, dynamic>? contentsNew;

  @JsonKey(name: "contents_old")
  final Map<String, dynamic>? contentsOld;
}
//endregion

//region get detail
@JsonSerializable()
class DetailLogResponse {
  DetailLogResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory DetailLogResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailLogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailLogResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final DetailLogData data;
}

@JsonSerializable()
class DetailLogData {
  DetailLogData({
    required this.logId,
    required this.tableName,
    required this.moduleName,
    required this.contentsNew,
    required this.contentsOld,
  });

  factory DetailLogData.fromJson(Map<String, dynamic> json) =>
      _$DetailLogDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailLogDataToJson(this);

  @JsonKey(name: "log_id")
  final String logId;

  @JsonKey(name: "table_name")
  final String tableName;

  @JsonKey(name: "module_name")
  final String moduleName;

  @JsonKey(name: "contents_new")
  final Map<String, dynamic>? contentsNew;

  @JsonKey(name: "contents_old")
  final Map<String, dynamic>? contentsOld;
}
//endregion