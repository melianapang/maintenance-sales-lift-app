import 'package:json_annotation/json_annotation.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_dto.dart';

part 'project_dto.g.dart';

//region get all unit
@JsonSerializable()
class GetAllProjectResponse {
  GetAllProjectResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListProjectData data;
}

@JsonSerializable()
class ListProjectData {
  ListProjectData({
    required this.totalSize,
    required this.result,
  });

  factory ListProjectData.fromJson(Map<String, dynamic> json) =>
      _$ListProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListProjectDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<ProjectData> result;
}

@JsonSerializable()
class ProjectData {
  ProjectData({
    required this.projectId,
    required this.projectNeed,
    required this.projectName,
    required this.salesOwnedId,
    required this.lastFollowUpResult,
    required this.address,
    required this.city,
    required this.longitude,
    required this.latitude,
    required this.customerId,
    required this.customerName,
    required this.companyName,
    required this.pics,
    this.isBgRed,
    this.documents,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDataToJson(this);

  @JsonKey(name: "project_id")
  final String projectId;

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "project_need")
  final String projectNeed;

  @JsonKey(name: "user_owned_id")
  final String salesOwnedId;

  @JsonKey(name: "last_follow_up_result")
  final String? lastFollowUpResult;

  @JsonKey(name: "longitude")
  final String longitude;

  @JsonKey(name: "latitude")
  final String latitude;

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "is_bg_red")
  final bool? isBgRed;

  @JsonKey(name: "pics")
  final List<PICProject> pics;

  @JsonKey(name: "documents")
  final List<DocumentData>? documents;
}

@JsonSerializable()
class PICProject {
  PICProject({
    this.picId,
    required this.picName,
    required this.role,
    required this.email,
    required this.phoneNumber,
  });

  factory PICProject.fromJson(Map<String, dynamic> json) =>
      _$PICProjectFromJson(json);

  Map<String, dynamic> toJson() => _$PICProjectToJson(this);

  @JsonKey(name: "pic_id")
  final String? picId;

  @JsonKey(name: "pic_name")
  final String picName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "role")
  final String role;

  @JsonKey(name: "email")
  final String email;
}
//endregion

//region create project
@JsonSerializable()
class CreateProjectRequest {
  CreateProjectRequest({
    required this.projectName,
    required this.projectNeed,
    required this.address,
    required this.city,
    required this.customerId,
    required this.longitude,
    required this.latitude,
    required this.scheduleDate,
  });

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProjectRequestToJson(this);

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "project_need")
  final int projectNeed;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "customer_id")
  final int customerId;

  @JsonKey(name: "longitude")
  final double longitude;

  @JsonKey(name: "latitude")
  final double latitude;

  @JsonKey(name: "schedule_date")
  final String scheduleDate;
}

@JsonSerializable()
class CreateProjectResponse {
  CreateProjectResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CreateProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final CreatedProjectIdResponse data;
}

@JsonSerializable()
class CreatedProjectIdResponse {
  CreatedProjectIdResponse({
    required this.projectId,
  });

  factory CreatedProjectIdResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedProjectIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedProjectIdResponseToJson(this);

  @JsonKey(name: "project_id")
  final int projectId;
}
//endregion

//region create pic
@JsonSerializable()
class CreatePICProjectRequest {
  CreatePICProjectRequest({
    required this.projectId,
    required this.picName,
    required this.phoneNumber,
    required this.email,
    required this.role,
  });

  factory CreatePICProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePICProjectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePICProjectRequestToJson(this);

  @JsonKey(name: "project_id")
  final int projectId;

  @JsonKey(name: "pic_name")
  final String picName;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "role")
  final String role;

  @JsonKey(name: "email")
  final String email;
}

@JsonSerializable()
class CreatePICProjectResponse {
  CreatePICProjectResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreatePICProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePICProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePICProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region delete pic
@JsonSerializable()
class DeletePICProjectResponse {
  DeletePICProjectResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeletePICProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletePICProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePICProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region list distinct pic role
@JsonSerializable()
class ListDistinctPICRoleResponse {
  ListDistinctPICRoleResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ListDistinctPICRoleResponse.fromJson(Map<String, dynamic> json) =>
      _$ListDistinctPICRoleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListDistinctPICRoleResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}
//endregion

//region update project
@JsonSerializable()
class UpdateProjectRequest {
  UpdateProjectRequest({
    required this.projectName,
    required this.projectNeed,
    required this.address,
    required this.city,
    required this.customerId,
    required this.longitude,
    required this.latitude,
  });

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProjectRequestToJson(this);

  @JsonKey(name: "project_name")
  final String projectName;

  @JsonKey(name: "project_need")
  final int projectNeed;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "customer_id")
  final int customerId;

  @JsonKey(name: "longitude")
  final double longitude;

  @JsonKey(name: "latitude")
  final double latitude;
}

@JsonSerializable()
class UpdateProjectResponse {
  UpdateProjectResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UpdateProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}
//endregion

//region delete user
@JsonSerializable()
class DeleteProjectResponse {
  DeleteProjectResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get project detail
@JsonSerializable()
class ProjectDetailResponse {
  ProjectDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ProjectData data;
}
//endregion