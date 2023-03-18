import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class ManageProfileItemModel {
  final String title;
  final IconData icon;
  String? route;
  void Function({
    required BuildContext context,
  })? callback;

  ManageProfileItemModel(this.title, this.icon, this.route, this.callback);
}

List<ManageProfileItemModel> manageProfileMenu = <ManageProfileItemModel>[
  ManageProfileItemModel(
    "Ubah Kata Sandi",
    PhosphorIcons.lockBold,
    Routes.changePassword,
    null,
  ),
  ManageProfileItemModel(
    "Keluar",
    PhosphorIcons.signOutBold,
    null,
    ({required context}) {
      showDialogWidget(
        context,
        title: 'Keluar',
        description: 'Anda yakin ingin Keluar?',
        positiveLabel: 'Iya',
        negativeLabel: 'Tidak',
        positiveCallback: () {},
        negativeCallback: () {},
      );
    },
  ),
];
