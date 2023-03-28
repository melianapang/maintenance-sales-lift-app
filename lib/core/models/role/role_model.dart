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

String mappingRole(Role role) {
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
