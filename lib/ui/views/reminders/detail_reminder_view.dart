import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailReminderView extends StatefulWidget {
  const DetailReminderView({super.key});

  @override
  State<DetailReminderView> createState() => _DetailReminderViewState();
}

class _DetailReminderViewState extends State<DetailReminderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: 'Data Pengingat',
        isBackEnabled: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Spacings.vert(32),
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
              Spacings.vert(42),
              TextInput.disabled(
                label: "Tanggal",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Waktu Pengingat",
              ),
              Spacings.vert(24),
              TextInput.disabledMultiline(
                label: "Catatan",
                text:
                    "CatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatanCatatan",
              ),
              Spacings.vert(24),
            ],
          ),
        ),
      ),
    );
  }
}
