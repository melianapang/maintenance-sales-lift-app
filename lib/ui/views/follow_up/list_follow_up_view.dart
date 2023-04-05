import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/list_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListFollowUpView extends StatefulWidget {
  const ListFollowUpView({super.key});

  @override
  State<ListFollowUpView> createState() => _ListFollowUpViewState();
}

class _ListFollowUpViewState extends State<ListFollowUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListFollowUpViewModel(),
      onModelReady: (ListFollowUpViewModel model) async {
        await model.initModel();
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
                        title: "Nadia Ang",
                        description: "PT ABC JAYA",
                        description2: "12 March 2023",
                        titleSize: 20,
                        descSize: 16,
                        desc2Size: 12,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.detailFollowUp);
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
