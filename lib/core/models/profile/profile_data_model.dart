import 'package:json_annotation/json_annotation.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';

part 'profile_data_model.g.dart';

@JsonSerializable()
class ProfileData {
  ProfileData({
    required this.username,
    required this.name,
    this.address = "",
    this.city = "",
    this.phoneNumber = "",
    required this.email,
    required this.role,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

  String username;
  String name;
  String address;
  String city;
  String phoneNumber;
  String email;
  Role role;
}
