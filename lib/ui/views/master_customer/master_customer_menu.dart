import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';

class MasterCustomerMenuView extends StatefulWidget {
  const MasterCustomerMenuView({
    super.key,
  });

  @override
  State<MasterCustomerMenuView> createState() => _MasterCustomerMenuViewState();
}

class _MasterCustomerMenuViewState extends State<MasterCustomerMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Master Pelanggan",
        isBackEnabled: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: PaddingUtils.getPadding(
            context,
            defaultPadding: 12,
          ),
          child: Column(
            children: [
              _buildSubMenuSection(
                "Tipe Pelanggan",
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.listCustomerType,
                ),
              ),
              Spacings.vert(24),
              _buildSubMenuSection(
                "Keperluan Pelanggan",
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.listCustomerNeed,
                ),
              ),
              Spacings.vert(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuSection(String title, {required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      color: MyColors.darkBlack02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 14.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              maxLines: 3,
              textAlign: TextAlign.center,
              minFontSize: 16,
              maxFontSize: 18,
              overflow: TextOverflow.ellipsis,
              style: buildTextStyle(
                fontColor: MyColors.lightBlack02,
                fontSize: 16,
                fontWeight: 500,
              ),
            ),
            Spacings.vert(12),
            ButtonWidget(
              buttonType: ButtonType.primary,
              text: "Lihat Data",
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
