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
  final int projectNeed;

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
    required this.picName,
    required this.phoneNumber,
  });

  factory PICProject.fromJson(Map<String, dynamic> json) =>
      _$PICProjectFromJson(json);

  Map<String, dynamic> toJson() => _$PICProjectToJson(this);

  @JsonKey(name: "pic_ame")
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
  });

  factory CreateProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProjectResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region update project
//update project cant change customer data
@JsonSerializable()
class UpdateProjectRequest {
  UpdateProjectRequest({
    required this.projectName,
    required this.projectNeed,
    required this.address,
    required this.city,
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