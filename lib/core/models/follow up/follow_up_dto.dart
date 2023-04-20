import 'package:json_annotation/json_annotation.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_dto.dart';

part 'follow_up_dto.g.dart';

@JsonSerializable()
class GetAllFollowUpResponse {
  GetAllFollowUpResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllFollowUpResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllFollowUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllFollowUpResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListFollowUpData data;
}

@JsonSerializable()
class ListFollowUpData {
  ListFollowUpData({
    required this.totalSize,
    required this.result,
  });

  factory ListFollowUpData.fromJson(Map<String, dynamic> json) =>
      _$ListFollowUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListFollowUpDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<FollowUpFrontData> result;
}

@JsonSerializable()
class FollowUpFrontData {
  FollowUpFrontData({
    required this.customerId,
    required this.customerName,
    required this.companyName,
  });

  factory FollowUpFrontData.fromJson(Map<String, dynamic> json) =>
      _$FollowUpFrontDataFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpFrontDataToJson(this);

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;
}

@JsonSerializable()
class FollowUpFileData {
  FollowUpFileData({
    required this.filePath,
    required this.fileType,
    required this.createdAt,
  });

  factory FollowUpFileData.fromJson(Map<String, dynamic> json) =>
      _$FollowUpFileDataFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpFileDataToJson(this);

  @JsonKey(name: "file_path")
  final String filePath;

  @JsonKey(name: "file_type")
  final String fileType;

  @JsonKey(name: "created_at")
  final String? createdAt;
}

@JsonSerializable()
class UpdateFollowUpRequest {
  UpdateFollowUpRequest({
    required this.userId,
    required this.unitId,
    required this.latitude,
    required this.longitude,
    required this.followUpResult,
    required this.scheduleDate,
    required this.note,
  });

  factory UpdateFollowUpRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFollowUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFollowUpRequestToJson(this);

  @JsonKey(name: "user_id")
  final int userId;

  @JsonKey(name: "unit_id")
  final int unitId;

  @JsonKey(name: "latitude")
  final double? latitude;

  @JsonKey(name: "longitude")
  final double? longitude;

  @JsonKey(name: "follow_up_result")
  final int followUpResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;
}

@JsonSerializable()
class UpdateFollowUpResponse {
  UpdateFollowUpResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UpdateFollowUpResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateFollowUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFollowUpResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}

//region detail FollowUp
@JsonSerializable()
class FollowUpDetailResponse {
  FollowUpDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory FollowUpDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowUpDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final FollowUpFrontData data;
}

@JsonSerializable()
class DetailFollowUpData {
  DetailFollowUpData({
    required this.followUpId,
    required this.customerName,
    required this.followUpResult,
    required this.scheduleDate,
    required this.note,
    required this.documents,
  });

  factory DetailFollowUpData.fromJson(Map<String, dynamic> json) =>
      _$DetailFollowUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailFollowUpDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final String followUpId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "follow_up_result")
  final String followUpResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "documentss")
  final List<FollowUpFrontData>? documents;
}
//endregion

//get history FollowUp
@JsonSerializable()
class GetHistoryFollowUpResponse {
  GetHistoryFollowUpResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetHistoryFollowUpResponse.fromJson(Map<String, dynamic> json) =>
      _$GetHistoryFollowUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetHistoryFollowUpResponseToJson(this);

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
  final List<HistoryFollowUpData> result;
}

@JsonSerializable()
class HistoryFollowUpData {
  HistoryFollowUpData({
    required this.followUpId,
    required this.customerId,
    required this.customerName,
    required this.companyName,
    required this.followUpResult,
    required this.scheduleDate,
    required this.note,
    required this.documents,
  });

  factory HistoryFollowUpData.fromJson(Map<String, dynamic> json) =>
      _$HistoryFollowUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryFollowUpDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final String followUpId;

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "follow_up_result")
  final String followUpResult;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "documents")
  final List<DocumentData>? documents;
}
//endregion