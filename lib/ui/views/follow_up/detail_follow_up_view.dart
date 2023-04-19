import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/detail_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/form_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailFollowUpViewParam {
  DetailFollowUpViewParam({
    this.followUpId,
    this.customerId,
    this.customerName,
    this.companyName,
  });

  final String? followUpId;
  final String? customerId;
  final String? customerName;
  final String? companyName;
}

class DetailFollowUpView extends StatefulWidget {
  const DetailFollowUpView({
    required this.param,
    super.key,
  });

  final DetailFollowUpViewParam param;

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

    return ViewModel(
      model: DetailFollowUpViewModel(
        followUpId: widget.param.followUpId,
        customerId: widget.param.customerId,
        customerName: widget.param.customerName,
        companyName: widget.param.companyName,
        dioService: Provider.of<DioService>(context),
        navigationService: Provider.of<NavigationService>(context),
      ),
      onModelReady: (DetailFollowUpViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Riwayat Konfitmasi",
            isBackEnabled: true,
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.formFollowUp,
                      arguments: FormFollowUpViewParam())
                  .then((value) {
                if (value == null) return;
                if (value == true) {
                  model.requestGetHistoryFollowUp();
                }
              });
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model.customerName ?? "",
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
                    model.companyName ?? "",
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
                if (model.timelineData.isNotEmpty)
                  TimelineWidget(
                    listTimeline: model.timelineData,
                  ),
                if (model.timelineData.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Belum ada Riwayat Pemeliharaan untuk unit ini.",
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.lightBlack02.withOpacity(
                          0.5,
                        ),
                        fontWeight: 300,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
