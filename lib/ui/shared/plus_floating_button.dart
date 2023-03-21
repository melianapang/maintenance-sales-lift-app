import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';

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
      backgroundColor: MyColors.lightBlue01,
      foregroundColor: MyColors.white,
      shape: const CircleBorder(
        side: BorderSide.none,
      ),
      child: const Icon(
        PhosphorIcons.plusBold,
        color: MyColors.white,
        size: 18,
      ),
    );
  }
}
