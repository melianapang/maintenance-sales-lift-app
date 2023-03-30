import 'package:json_annotation/json_annotation.dart';

enum Role {
  @JsonValue('super_admin')
  SuperAdmin,
  @JsonValue('admin')
  Admin,
  @JsonValue('sales')
  Sales,
  @JsonValue('engineers')
  Engineers,
}

String mappingRoleToString(Role role) {
  switch (role) {
    case Role.SuperAdmin:
      return "Super Admin";
    case Role.Admin:
      return "Admin";
    case Role.Sales:
      return "Sales";
    case Role.Engineers:
      return "Teknisi";
  }
}

Role mappingStringToRole(String role) {
  switch (role) {
    case "1":
      return Role.Sales;
    case "2":
      return Role.Engineers;
    case "3":
      return Role.Admin;
    default:
      return Role.Admin;
  }
}
