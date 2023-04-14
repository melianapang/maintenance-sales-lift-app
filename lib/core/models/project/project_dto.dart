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
  final String projectNeed;

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