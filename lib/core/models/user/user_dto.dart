import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

//region create user
@JsonSerializable()
class CreateUserRequest {
  CreateUserRequest({
    required this.idRole,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.city,
    required this.address,
    required this.email,
    required this.passwordConfirmation,
    required this.password,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  @JsonKey(name: "id_role")
  final int idRole;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "password")
  final String password;

  @JsonKey(name: "password_confirmation")
  final String passwordConfirmation;
}

@JsonSerializable()
class CreateUserResponse {
  CreateUserResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region delete user
@JsonSerializable()
class DeleteUserResponse {
  DeleteUserResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteUserResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region update user
@JsonSerializable()
class UpdateUserRequest {
  UpdateUserRequest({
    required this.idRole,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.city,
    required this.address,
    required this.email,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @JsonKey(name: "id_role")
  final int idRole;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "email")
  final String email;
}

@JsonSerializable()
class UpdateUserResponse {
  UpdateUserResponse({
    required this.isSuccess,
    required this.message,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get all user
@JsonSerializable()
class GetAllUserResponse {
  GetAllUserResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllUserResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListUserData data;
}

@JsonSerializable()
class ListUserData {
  ListUserData({
    required this.totalSize,
    required this.result,
  });

  factory ListUserData.fromJson(Map<String, dynamic> json) =>
      _$ListUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListUserDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<UserData> result;
}

@JsonSerializable()
class UserData {
  UserData({
    required this.userId,
    required this.name,
    required this.username,
    required this.roleName,
    required this.address,
    required this.city,
    required this.phoneNumber,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @JsonKey(name: "user_id")
  final String userId;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "role_name")
  final String roleName;

  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "email")
  final String email;
}
//endregion

//region get user detail
@JsonSerializable()
class UserDetailResponse {
  UserDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final UserData data;
}
//endregion