import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/list_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class ListFollowUpView extends StatefulWidget {
  const ListFollowUpView({super.key});

  @override
  State<ListFollowUpView> createState() => _ListFollowUpViewState();
}

class _ListFollowUpViewState extends State<ListFollowUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListFollowUpViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListFollowUpViewModel model) async {
        await model.initModel();

        if (model.errorMsg != null)
          _buildErrorDialog(
            context,
            model,
          );
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Riwayat Konfirmasi",
            isBackEnabled: true,
          ),
          body: Column(
            children: [
              buildSearchBar(
                context,
                isEnabled: !model.busy && !model.isShowNoDataFoundPage,
                textSearchOnChanged: (text) {},
                isFilterShown: false,
                onTapFilter: () {},
              ),
              Spacings.vert(12),
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.requestGetAllFollowUp(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.listFollowUp.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: model.listFollowUp[index].customerName,
                          description: model.listFollowUp[index].companyName,
                          titleSize: 20,
                          descSize: 16,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailFollowUp,
                              arguments: DetailFollowUpViewParam(
                                customerId:
                                    model.listFollowUp[index].customerId,
                                companyName:
                                    model.listFollowUp[index].companyName,
                                customerName:
                                    model.listFollowUp[index].customerName,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Spacings.vert(16),
              ],
              if (model.isShowNoDataFoundPage && !model.busy)
                buildNoDataFoundPage(),
              if (model.busy) buildLoadingPage(),
            ],
          ),
        );
      },
    );
  }

  void _buildErrorDialog(
    BuildContext context,
    ListFollowUpViewModel model,
  ) {
    showDialogWidget(
      context,
      title: "Daftar Riwayat Konfirmasi",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Riwayat Konfirmasi. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.requestGetAllFollowUp();
        Navigator.pop(context);

        if (model.errorMsg != null) _buildErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
