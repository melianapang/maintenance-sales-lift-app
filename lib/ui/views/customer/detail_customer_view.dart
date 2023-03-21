import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailCustomerView extends StatefulWidget {
  const DetailCustomerView({super.key});

  @override
  State<DetailCustomerView> createState() => _DetailCustomerViewState();
}

class _DetailCustomerViewState extends State<DetailCustomerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGreyBackground,
      appBar: buildDefaultAppBar(
        context,
        title: "Data Pelanggan",
        isBackEnabled: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.editCustomer);
            },
            child: const Padding(
              padding: EdgeInsets.only(
                right: 20.0,
              ),
              child: Icon(
                PhosphorIcons.pencilSimpleLineBold,
                color: MyColors.darkBlue01,
                size: 16,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: () {},
            text: 'Daftar Pengingat',
          ),
          ButtonWidget(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: () {},
            text: 'Unggah Berkas PO',
          ),
          ButtonWidget(
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: () {},
            text: 'Riwayat Konfirmasi',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 24.0,
          bottom: 24.0,
          left: 24.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Spacings.vert(40),
              Text(
                "Nadia Ang",
                style: buildTextStyle(
                  fontSize: 32,
                  fontWeight: 800,
                  fontColor: MyColors.lightBlue01,
                ),
              ),
              Text(
                "PT ABC JAYA",
                style: buildTextStyle(
                  fontSize: 20,
                  fontWeight: 400,
                  fontColor: MyColors.lightBlue01,
                ),
              ),
              Spacings.vert(32),
              StatusCardWidget(
                cardType: StatusCardType.Confirmed,
                onTap: () {},
              ),
              Spacings.vert(35),
              TextInput.disabled(
                label: "Nomor Customer",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Kota",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "No Telepon",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
