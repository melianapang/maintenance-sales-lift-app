import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/list_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListProjectView extends StatefulWidget {
  const ListProjectView({super.key});

  @override
  State<ListProjectView> createState() => _ListProjectViewState();
}

class _ListProjectViewState extends State<ListProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListProjectViewModel(),
      onModelReady: (ListProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Proyek",
            isBackEnabled: true,
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.addProject);
            },
          ),
          body: Column(
            children: [
              buildSearchBar(
                context,
                isEnabled: !model.busy && !model.isShowNoDataFoundPage,
                textSearchOnChanged: (text) {},
                isFilterShown: false,
              ),
              Spacings.vert(12),
              if (!model.isShowNoDataFoundPage && !model.busy)
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 10,
                    separatorBuilder: (_, __) => const Divider(
                      color: MyColors.transparent,
                      height: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CustomCardWidget(
                        cardType: CardType.list,
                        title: "KA-23243",
                        description: "PT. ABC JAYA",
                        titleSize: 20,
                        descSize: 16,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.detailProject);
                        },
                      );
                    },
                  ),
                ),
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
