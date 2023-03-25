import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DetailMaintenanceView extends StatefulWidget {
  const DetailMaintenanceView({super.key});

  @override
  State<DetailMaintenanceView> createState() => _DetailMaintenanceViewState();
}

class _DetailMaintenanceViewState extends State<DetailMaintenanceView> {
  @override
  Widget build(BuildContext context) {
    final List<TimelineData> list1 = [
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Data Pemeliharaan",
        isBackEnabled: true,
      ),
      floatingActionButton: FloatingButtonWidget(
        onTap: () {
          Navigator.pushNamed(context, Routes.formMaintenance);
        },
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
                "KA-23243",
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
                cardType: StatusCardType.Defect,
                onTap: () {},
              ),
              Spacings.vert(35),
              TextInput.disabled(
                label: "Lokasi",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "PIC",
              ),
              Spacings.vert(24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Riwayat Pemeliharaan",
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.yellow01,
                    fontWeight: 400,
                  ),
                ),
              ),
              TimelineWidget(
                listTimeline: list1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
