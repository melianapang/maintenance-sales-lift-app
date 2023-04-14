import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'approval_dto.g.dart';

//region get all approval
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
    required this.totalSize,
    required this.result,
  });

  factory ListApprovalData.fromJson(Map<String, dynamic> json) =>
      _$ListApprovalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListApprovalDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<ApprovalData> result;
}

@JsonSerializable()
class ApprovalData {
  ApprovalData({
    required this.approvalId,
    required this.userRequestName,
    required this.userRequestPhoneNumber,
    required this.approvalStatus,
    required this.contentsNew,
    required this.contentsOld,
    required this.approvalDate,
  });

  factory ApprovalData.fromJson(Map<String, dynamic> json) =>
      _$ApprovalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalDataToJson(this);

  @JsonKey(name: "approval_id")
  final String approvalId;

  @JsonKey(name: "user_request_name")
  final String userRequestName;

  @JsonKey(name: "user_request_phone_number")
  final String userRequestPhoneNumber;

  @JsonKey(name: "status_approval")
  final String approvalStatus;

  @JsonKey(name: "contents_new")
  final Map<String, dynamic>? contentsNew;

  @JsonKey(name: "contents_old")
  final Map<String, dynamic>? contentsOld;

  @JsonKey(name: "approval_date")
  final String approvalDate;
}
//endregion

//region approval detail
@JsonSerializable()
class UpdateApprovalRequest {
  UpdateApprovalRequest({
    required this.approvalStatus,
  });

  factory UpdateApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApprovalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApprovalRequestToJson(this);

  @JsonKey(name: "status_approval")
  final int approvalStatus;
}

@JsonSerializable()
class UpdateApprovalResponse {
  UpdateApprovalResponse({
    required this.isSuccess,
    required this.message,
  });

  factory UpdateApprovalResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateApprovalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApprovalResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region update approval
@JsonSerializable()
class ApprovalDetailResponse {
  ApprovalDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ApprovalDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final DetailApprovalData data;
}

@JsonSerializable()
class DetailApprovalData {
  DetailApprovalData({
    required this.approvalId,
    required this.userRequestName,
    required this.userRequestPhoneNumber,
    required this.approvalStatus,
    required this.contentsNew,
    required this.contentsOld,
    required this.approvalDate,
  });

  factory DetailApprovalData.fromJson(Map<String, dynamic> json) =>
      _$DetailApprovalDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailApprovalDataToJson(this);

  @JsonKey(name: "approval_id")
  final int approvalId;

  @JsonKey(name: "user_request_name")
  final String userRequestName;

  @JsonKey(name: "user_request_phone_number")
  final String userRequestPhoneNumber;

  @JsonKey(name: "status_approval")
  final String approvalStatus;

  @JsonKey(name: "contents_new")
  final Map<String, dynamic>? contentsNew;

  @JsonKey(name: "contents_old")
  final Map<String, dynamic>? contentsOld;

  @JsonKey(name: "approval_date")
  final String approvalDate;
}
//endregion