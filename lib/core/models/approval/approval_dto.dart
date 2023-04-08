import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'approval_dto.g.dart';

@JsonSerializable()
class GetAllApprovalResponse {
  GetAllApprovalResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllApprovalResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllApprovalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllApprovalResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListApprovalData data;
}

@JsonSerializable()
class ListApprovalData {
  ListApprovalData({
    required this.result,
  });

  factory ListApprovalData.fromJson(Map<String, dynamic> json) =>
      _$ListApprovalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListApprovalDataToJson(this);

  @JsonKey(name: "result")
  final List<ApprovalData> result;
}

@JsonSerializable()
class ApprovalData {
  ApprovalData({
    required this.logId,
    required this.userCreatedId,
    required this.changeId,
    required this.tableName,
    required this.modulenName,
    required this.contentsNew,
    required this.contentsOld,
  });

  factory ApprovalData.fromJson(Map<String, dynamic> json) =>
      _$ApprovalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalDataToJson(this);

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
