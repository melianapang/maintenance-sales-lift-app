import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'role/role_model.dart';
import '../app_constants/routes.dart';

class HomeItemModel {
  final String title;
  final IconData icon;
  final List<Role> role;
  final String route;

  HomeItemModel(this.title, this.icon, this.role, this.route);
}

List<HomeItemModel> homeMenu = <HomeItemModel>[
  HomeItemModel(
    "Permohonan",
    PhosphorIcons.calendarBlankBold,
    <Role>[
      Role.Admin,
      Role.SuperAdmin,
    ],
    Routes.listApproval,
  ),
  HomeItemModel(
    "Users",
    PhosphorIcons.usersBold,
    <Role>[
      Role.Admin,
      Role.SuperAdmin,
    ],
    Routes.listUser,
  ),
  HomeItemModel(
    "Log",
    PhosphorIcons.folderBold,
    <Role>[
      Role.Admin,
      Role.SuperAdmin,
    ],
    Routes.listLog,
  ),
  HomeItemModel(
    "Master Pelanggan",
    PhosphorIcons.folderUserBold,
    <Role>[
      Role.Admin,
      Role.SuperAdmin,
    ],
    Routes.masterCustomerMenu,
  ),
  HomeItemModel(
    "Proyek",
    PhosphorIcons.monitor,
    <Role>[
      Role.Sales,
    ],
    Routes.listProjects,
  ),
  HomeItemModel(
    "Pelanggan",
    PhosphorIcons.usersBold,
    <Role>[
      Role.Sales,
    ],
    Routes.listCustomer,
  ),
  HomeItemModel(
    "Pengingat",
    PhosphorIcons.bellBold,
    <Role>[
      Role.SuperAdmin,
      Role.Admin,
      Role.Sales,
      Role.Engineers,
    ],
    Routes.listReminder,
  ),
  HomeItemModel(
    "Riwayat Konfirmasi",
    Icons.list,
    <Role>[
      Role.Sales,
    ],
    Routes.listFollowUp,
  ),
  HomeItemModel(
    "Jadwal Pemeliharaan",
    PhosphorIcons.listBulletsBold,
    <Role>[
      Role.Engineers,
    ],
    Routes.listMaintenance,
  ),
];
