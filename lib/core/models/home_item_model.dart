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
    ],
    Routes.listApproval,
  ),
  HomeItemModel(
    "Users",
    PhosphorIcons.usersBold,
    <Role>[
      Role.Admin,
    ],
    Routes.listUser,
  ),
  HomeItemModel(
    "Proyek",
    PhosphorIcons.monitor,
    <Role>[
      Role.Admin,
    ],
    Routes.listProjects,
  ),
  HomeItemModel(
    "Log",
    PhosphorIcons.folderBold,
    <Role>[
      Role.Admin,
    ],
    Routes.listLog,
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
