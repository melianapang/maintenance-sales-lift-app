import 'package:json_annotation/json_annotation.dart';

part 'document_dto.g.dart';

//region create document
@JsonSerializable()
class CreateDocumentRequest {
  CreateDocumentRequest({
    required this.fileType,
    required this.filePath,
    required this.note,
    required this.projectId,
  });

  factory CreateDocumentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDocumentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocumentRequestToJson(this);

  @JsonKey(name: "file_type")
  final int fileType;

  @JsonKey(name: "file_path")
  final String filePath;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "project_id")
  final int projectId;
}

@JsonSerializable()
class CreateDocumentResponse {
  CreateDocumentResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateDocumentResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDocumentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocumentResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region document data
@JsonSerializable()
class DocumentData {
  DocumentData({
    required this.filePath,
    required this.fileType,
    required this.createdAt,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) =>
      _$DocumentDataFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentDataToJson(this);

  @JsonKey(name: "file_path")
  final String filePath;

  @JsonKey(name: "file_type")
  final String fileType;

  @JsonKey(name: "created_at")
  final String? createdAt;
}
//endregion

//region get all document
@JsonSerializable()
class GetAllDocumentResponse {
  GetAllDocumentResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllDocumentResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllDocumentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllDocumentResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListDocumentData data;
}

@JsonSerializable()
class ListDocumentData {
  ListDocumentData({
    required this.totalSize,
    required this.result,
  });

  factory ListDocumentData.fromJson(Map<String, dynamic> json) =>
      _$ListDocumentDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListDocumentDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<DocumentData> result;
}
//endregion