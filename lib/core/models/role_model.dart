enum Role { SuperAdmin, Admin, Sales, Engineers }

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
