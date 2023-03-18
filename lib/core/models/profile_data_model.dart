import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';

class ProfileData {
  ProfileData({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.notelp,
    required this.email,
    required this.role,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String notelp;
  final String email;
  final Role role;
}
