import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/approval/list_approval_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/approval/detail_approval_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListApprovalView extends StatefulWidget {
  const ListApprovalView({super.key});

  @override
  State<ListApprovalView> createState() => _ListApprovalViewState();
}

class _ListApprovalViewState extends State<ListApprovalView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListApprovalViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListApprovalViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Daftar Permohonan",
            isBackEnabled: true,
          ),
          body: Column(
            children: [
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Spacings.vert(12),
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.requestGetAllApproval(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.listApproval?.length ?? 0,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: StringUtils.removeZeroWidthSpaces(
                              model.listApproval?[index].userRequestName ?? ""),
                          description: "Edit Data Request",
                          descSize: 16,
                          titleSize: 20,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailApproval,
                              arguments: DetailApprovalViewParam(
                                approvalData: model.listApproval?[index],
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
}
