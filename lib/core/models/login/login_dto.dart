import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class CheckNumberRequest {
  CheckNumberRequest({
    required this.phoneNumber,
  });

  factory CheckNumberRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckNumberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckNumberRequestToJson(this);

  @JsonKey(name: "phone_number")
  final String phoneNumber;
}

@JsonSerializable()
class CheckNumberResponse {
  CheckNumberResponse({
    required this.result,
  });

  factory CheckNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckNumberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckNumberResponseToJson(this);

  final CheckNumberRequestResult result;
}

@JsonSerializable()
class CheckNumberRequestResult {
  CheckNumberRequestResult({
    required this.accountId,
  });

  factory CheckNumberRequestResult.fromJson(Map<String, dynamic> json) =>
      _$CheckNumberRequestResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckNumberRequestResultToJson(this);

  @JsonKey(name: "account_id")
  final String accountId;
}

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
