import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlusFloatingButtonWidget extends StatelessWidget {
  const PlusFloatingButtonWidget({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: MyColors.lightBlack01,
      foregroundColor: MyColors.yellow01,
      shape: const CircleBorder(
        side: BorderSide.none,
      ),
      child: const Icon(
        PhosphorIcons.plusBold,
        color: MyColors.yellow01,
        size: 18,
      ),
    );
  }
}
