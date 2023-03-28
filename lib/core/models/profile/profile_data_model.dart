import 'package:json_annotation/json_annotation.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';

part 'profile_data_model.g.dart';

@JsonSerializable()
class ProfileData {
  ProfileData({
    required this.username,
    this.firstName = "",
    this.lastName = "",
    this.address = "",
    this.city = "",
    this.notelp = "",
    required this.email,
    required this.role,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

  final String username;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String notelp;
  final String email;
  final Role role;
}
