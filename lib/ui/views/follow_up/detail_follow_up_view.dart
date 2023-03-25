import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailFollowUpView extends StatefulWidget {
  const DetailFollowUpView({super.key});

  @override
  State<DetailFollowUpView> createState() => _DetailFollowUpViewState();
}

class _DetailFollowUpViewState extends State<DetailFollowUpView> {
  @override
  Widget build(BuildContext context) {
    final List<TimelineData> list1 = [
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryFollowUp);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryFollowUp);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryFollowUp);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryFollowUp);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Riwayat Konfitmasi",
        isBackEnabled: true,
      ),
      floatingActionButton: FloatingButtonWidget(
        onTap: () {
          Navigator.pushNamed(context, Routes.formFollowUp);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nadia Ang",
                style: buildTextStyle(
                  fontSize: 26,
                  fontWeight: 800,
                  fontColor: MyColors.yellow01,
                ),
              ),
            ),
            Spacings.vert(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PT ABC JAYA",
                style: buildTextStyle(
                  fontSize: 20,
                  fontWeight: 400,
                  fontColor: MyColors.lightBlack02,
                ),
              ),
            ),
            Spacings.vert(38),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Konfirmasi Terakhir",
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
    );
  }
}
