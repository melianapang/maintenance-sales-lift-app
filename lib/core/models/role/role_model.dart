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
    case "Super Admin":
      return Role.SuperAdmin;
    case "Admin":
      return Role.Admin;
    case "Sales":
      return Role.Engineers;
    case "Teknisi":
      return Role.Sales;
    default:
      return Role.Admin;
  }
}

Role mappingStringNumberToRole(String role) {
  switch (role) {
    case "1":
      return Role.SuperAdmin;
    case "2":
      return Role.Admin;
    case "3":
      return Role.Engineers;
    case "4":
      return Role.Sales;
    default:
      return Role.Admin;
  }
}

String mappingRoleToNumberString(Role role) {
  switch (role) {
    case Role.SuperAdmin:
      return "1";
    case Role.Admin:
      return "2";
    case Role.Sales:
      return "3";
    case Role.Engineers:
      return "4";
  }
}
