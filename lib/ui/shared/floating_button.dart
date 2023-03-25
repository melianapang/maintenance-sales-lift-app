import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({
    required this.onTap,
    this.icon = PhosphorIcons.plusBold,
    super.key,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: MyColors.lightBlack01,
      foregroundColor: MyColors.yellow01,
      shape: const CircleBorder(
        side: BorderSide.none,
      ),
      child: Icon(
        icon,
        color: MyColors.yellow01,
        size: 18,
      ),
    );
  }
}
