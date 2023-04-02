import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

//login
@JsonSerializable()
class LoginRequest {
  LoginRequest({
    required this.inputUser,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @JsonKey(name: "input_user")
  final String inputUser;

  @JsonKey(name: "password")
  final String password;
}

@JsonSerializable()
class LoginResponse {
  LoginResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final TokenData data;
}

@JsonSerializable()
class TokenData {
  TokenData({required this.token});

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);

  @JsonKey(name: "token")
  final String token;
}
