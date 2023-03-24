import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/list_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/filter_menu.dart';

class ListMaintenanceView extends StatefulWidget {
  const ListMaintenanceView({super.key});

  @override
  State<ListMaintenanceView> createState() => _ListMaintenanceViewState();
}

class _ListMaintenanceViewState extends State<ListMaintenanceView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListMaintenanceViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Jadwal Pemeliharaan",
            isBackEnabled: true,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.exportMaintenance);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: Icon(
                    PhosphorIcons.exportBold,
                    color: MyColors.lightBlack02,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              buildSearchBar(
                context,
                textSearchOnChanged: (text) {},
                isFilterShown: true,
                onTapFilter: () {
                  showMaintenanceFilterMenu(context,
                      listHandledByMenu: model.handledByOptions,
                      listSortMenu: model.sortOptions,
                      selectedHandledBy: model.selectedSumberDataOption,
                      selectedSort: model.selectedSortOption,
                      terapkanCallback: model.terapkanFilter);
                },
              ),
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
                        title: "KA-23243",
                        description: "PT ABC JAYA",
                        description2: "12 March 2023",
                        titleSize: 20,
                        descSize: 16,
                        desc2Size: 12,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.detailMaintenance);
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}