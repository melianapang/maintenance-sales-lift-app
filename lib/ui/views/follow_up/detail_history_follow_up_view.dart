import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailHistoryFollowUpView extends StatefulWidget {
  const DetailHistoryFollowUpView({super.key});

  @override
  State<DetailHistoryFollowUpView> createState() =>
      _DetailHistoryFollowUpViewState();
}

class _DetailHistoryFollowUpViewState extends State<DetailHistoryFollowUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Detail Riwayat Konfirmasi",
        isBackEnabled: true,
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
              Spacings.vert(20),
              Text(
                "Nadia Ang",
                style: buildTextStyle(
                  fontSize: 32,
                  fontWeight: 800,
                  fontColor: MyColors.yellow01,
                ),
              ),
              Text(
                "PT ABC JAYA",
                style: buildTextStyle(
                  fontSize: 20,
                  fontWeight: 400,
                  fontColor: MyColors.lightBlack02,
                ),
              ),
              Spacings.vert(35),
              StatusCardWidget(
                cardType: StatusCardType.Pending,
                onTap: () {},
              ),
              Spacings.vert(35),
              TextInput.disabled(
                label: "Tanggal",
              ),
              Spacings.vert(24),
              TextInput.disabledMultiline(
                label: "Catatan",
                text:
                    "CatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatan",
              ),
              Spacings.vert(24),
            ],
          ),
        ),
      ),
    );
  }
}
