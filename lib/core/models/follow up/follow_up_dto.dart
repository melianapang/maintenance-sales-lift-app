import 'package:json_annotation/json_annotation.dart';

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
    required this.projectId,
    required this.projectName,
    required this.customerId,
    required this.customerName,
    required this.companyName,
    required this.followUpId,
    required this.salesOwnedId,
    required this.scheduleDate,
  });

  factory FollowUpFrontData.fromJson(Map<String, dynamic> json) =>
      _$FollowUpFrontDataFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpFrontDataToJson(this);

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "follow_up_id")
  final String? followUpId;

  @JsonKey(name: "user_owned_id")
  final String? salesOwnedId;

  @JsonKey(name: "schedule_date")
  final String? scheduleDate;
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
    required this.projectId,
    required this.followUpResult,
    required this.scheduleDate,
    required this.followUpFiles,
    required this.note,
  });

  factory UpdateFollowUpRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFollowUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFollowUpRequestToJson(this);

  @JsonKey(name: "project_id")
  final int projectId;

  @JsonKey(name: "follow_up_result")
  final int followUpResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "follow_up_files")
  final List<FollowUpFile>? followUpFiles;

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
  final FollowUpIdData data;
}

@JsonSerializable()
class FollowUpIdData {
  FollowUpIdData({
    required this.followUpId,
  });

  factory FollowUpIdData.fromJson(Map<String, dynamic> json) =>
      _$FollowUpIdDataFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpIdDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final int followUpId;
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
  final DetailFollowUpData data;
}

@JsonSerializable()
class DetailFollowUpData {
  DetailFollowUpData(
      {required this.followUpId,
      required this.projectId,
      required this.projectName,
      required this.customerName,
      required this.companyName,
      required this.followUpResult,
      required this.scheduleDate,
      required this.note,
      required this.followUpFiles,
      required this.salesOwnedId});

  factory DetailFollowUpData.fromJson(Map<String, dynamic> json) =>
      _$DetailFollowUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$DetailFollowUpDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final String followUpId;

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "follow_up_result")
  final String followUpResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "sales_owned_id")
  final String salesOwnedId;

  @JsonKey(name: "follow_up_files")
  final List<FollowUpFile>? followUpFiles;
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
    required this.projectId,
    required this.projectName,
    required this.customerName,
    required this.companyName,
    required this.followUpResult,
    required this.scheduleDate,
    required this.note,
    required this.followUpFiles,
  });

  factory HistoryFollowUpData.fromJson(Map<String, dynamic> json) =>
      _$HistoryFollowUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryFollowUpDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final String followUpId;

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "customer_name")
  final String? customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "follow_up_result")
  final String followUpResult;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "follow_up_files")
  final List<FollowUpFile>? followUpFiles;
}
//endregion

//region create follow up
@JsonSerializable()
class CreateFollowUpRequest {
  CreateFollowUpRequest({
    required this.projectId,
    required this.followUpResult,
    required this.scheduleDate,
    required this.note,
    required this.followUpFiles,
  });

  factory CreateFollowUpRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFollowUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFollowUpRequestToJson(this);

  @JsonKey(name: "project_id")
  final int projectId;

  @JsonKey(name: "follow_up_result")
  final int followUpResult;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;

  @JsonKey(name: "follow_up_files")
  final List<FollowUpFile>? followUpFiles;
}

@JsonSerializable()
class CreateFollowUpResponse {
  CreateFollowUpResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateFollowUpResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFollowUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFollowUpResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region follow up data
@JsonSerializable()
class FollowUpFile {
  FollowUpFile({
    required this.filePath,
  });

  factory FollowUpFile.fromJson(Map<String, dynamic> json) =>
      _$FollowUpFileFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpFileToJson(this);

  @JsonKey(name: "file_path")
  final String filePath;
}
//endregion

//region get next follow up date by project id
@JsonSerializable()
class GetNextFollowUpDateResponse {
  GetNextFollowUpDateResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetNextFollowUpDateResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNextFollowUpDateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNextFollowUpDateResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final NextFollowUpDateData data;
}

@JsonSerializable()
class NextFollowUpDateData {
  NextFollowUpDateData({
    required this.followUpId,
    required this.scheduleDate,
  });

  factory NextFollowUpDateData.fromJson(Map<String, dynamic> json) =>
      _$NextFollowUpDateDataFromJson(json);

  Map<String, dynamic> toJson() => _$NextFollowUpDateDataToJson(this);

  @JsonKey(name: "follow_up_id")
  final String followUpId;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;
}
//endregion