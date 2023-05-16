import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/detail_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/form_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';

class DetailFollowUpViewParam {
  DetailFollowUpViewParam({
    this.customerId,
    this.customerName,
    this.companyName,
  });

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
    return ViewModel(
      model: DetailFollowUpViewModel(
        customerId: widget.param.customerId,
        customerName: widget.param.customerName,
        companyName: widget.param.companyName,
        dioService: Provider.of<DioService>(context),
        navigationService: Provider.of<NavigationService>(context),
      ),
      onModelReady: (DetailFollowUpViewModel model) async {
        await model.initModel();
        _handleErrorDialog(context, model);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Daftar Riwayat Konfirmasi",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.formFollowUp,
                arguments: FormFollowUpViewParam(
                    customerData: CustomerData(
                  customerId: model.customerId ?? "",
                  customerName: model.customerName ?? "",
                  companyName: model.companyName,
                  city: "",
                  customerNeed: "",
                  customerNumber: "",
                  customerType: "",
                  phoneNumber: "",
                  email: "",
                  dataSource: "",
                  isLead: "",
                  status: "",
                )),
              ).then((value) {
                if (value == null) return;
                if (value == true) {
                  model.requestGetHistoryFollowUp();
                  model.setPreviousPageNeedRefresh(true);
                }
              });
            },
          ),
          body: !model.busy
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        model.customerName ?? "",
                        style: buildTextStyle(
                          fontSize: 26,
                          fontWeight: 800,
                          fontColor: MyColors.yellow01,
                        ),
                      ),
                      Spacings.vert(8),
                      Text(
                        model.companyName ?? "",
                        style: buildTextStyle(
                          fontSize: 20,
                          fontWeight: 400,
                          fontColor: MyColors.lightBlack02,
                        ),
                      ),
                      Spacings.vert(24),
                      StatusCardWidget(
                        cardType: model.statusCardType,
                        onTap: () {},
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
                            "Belum ada Riwayat Konfirmasi untuk unit ini.",
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
                )
              : Column(
                  children: [
                    buildLoadingPage(),
                  ],
                ),
        );
      },
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    DetailFollowUpViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Riwayat Konfirmasi",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Riwayat. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        await model.refreshPage();

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
