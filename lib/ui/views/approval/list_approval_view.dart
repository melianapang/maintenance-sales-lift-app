import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/approval/list_approval_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
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
      model: ListApprovalViewModel(),
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
              buildSearchBar(
                context,
                isFilterShown: false,
                textSearchOnChanged: (text) {},
                onTapFilter: () {},
              ),
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Spacings.vert(12),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 10,
                    separatorBuilder: (context, index) => const Divider(
                      color: MyColors.transparent,
                      height: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CustomCardWidget(
                        cardType: CardType.list,
                        title: "Nikimia Robertson",
                        description: "Edit Data Request",
                        desc2Size: 16,
                        titleSize: 20,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.detailApproval);
                        },
                      );
                    },
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
