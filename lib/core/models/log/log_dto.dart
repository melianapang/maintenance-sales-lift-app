import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'log_dto.g.dart';

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
    required this.result,
  });

  factory ListLogData.fromJson(Map<String, dynamic> json) =>
      _$ListLogDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListLogDataToJson(this);

  @JsonKey(name: "result")
  final List<LogData> result;
}

@JsonSerializable()
class LogData {
  LogData({
    required this.logId,
    required this.userCreatedId,
    required this.changeId,
    required this.tableName,
    required this.modulenName,
    required this.contentsNew,
    required this.contentsOld,
  });

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  @JsonKey(name: "id")
  final String logId;

  @JsonKey(name: "user_created_id")
  final String userCreatedId;

  @JsonKey(name: "changed_id")
  final String changeId;

  @JsonKey(name: "table_name")
  final String tableName;

  @JsonKey(name: "module_name")
  final String modulenName;

  @JsonKey(name: "contents_new")
  final Map<String, dynamic>? contentsNew;

  @JsonKey(name: "contents_old")
  final Map<String, dynamic>? contentsOld;
}
