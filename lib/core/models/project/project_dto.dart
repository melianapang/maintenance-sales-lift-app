import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

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
    required this.address,
    required this.city,
    required this.customerId,
    required this.customerName,
    required this.pics,
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

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "pics")
  final List<PICProject> pics;
}

@JsonSerializable()
class PICProject {
  PICProject({
    this.picId,
    required this.picName,
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

//region update project
@JsonSerializable()
class UpdateProjectRequest {
  UpdateProjectRequest({
    required this.projectName,
    required this.projectNeed,
    required this.address,
    required this.city,
    required this.customerId,
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