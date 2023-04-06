import 'package:json_annotation/json_annotation.dart';

part 'failure_dto.g.dart';

@JsonSerializable()
class Failure {
  Failure({
    this.errorCode,
    required this.message,
  });

  factory Failure.fromJson(Map<String, dynamic> json) =>
      _$FailureFromJson(json);

  Map<String, dynamic> toJson() => _$FailureToJson(this);

  final int? errorCode;
  final String message;
}
