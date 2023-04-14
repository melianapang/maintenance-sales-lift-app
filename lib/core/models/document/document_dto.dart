import 'package:json_annotation/json_annotation.dart';

part 'document_dto.g.dart';

//region create document
@JsonSerializable()
class CreateDocumentRequest {
  CreateDocumentRequest({
    required this.fileType,
    required this.filePath,
    required this.note,
    required this.customerId,
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

  @JsonKey(name: "customer_id")
  final int customerId;
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