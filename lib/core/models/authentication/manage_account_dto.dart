import 'package:json_annotation/json_annotation.dart';

part 'manage_account_dto.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  ChangePasswordRequest(
      {required this.oldPassword,
      required this.newPassword,
      required this.passwordConfirmation});

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  @JsonKey(name: "old_password")
  final String oldPassword;

  @JsonKey(name: "new_password")
  final String newPassword;

  @JsonKey(name: "password_confirmation")
  final String passwordConfirmation;
}

@JsonSerializable()
class ChangePasswordResponse {
  ChangePasswordResponse({
    required this.isSuccess,
    required this.message,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
