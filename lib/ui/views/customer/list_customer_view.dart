import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/list_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/plus_floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListCustomerView extends StatefulWidget {
  const ListCustomerView({super.key});

  @override
  State<ListCustomerView> createState() => _ListCustomerViewState();
}

class _ListCustomerViewState extends State<ListCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<ListCustomerViewModel>(
      model: ListCustomerViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          floatingActionButton: PlusFloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.addCustomer);
            },
          ),
          appBar: buildDefaultAppBar(
            context,
            title: "Pelanggan",
            isBackEnabled: true,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.exportCustomer);
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
                textSearchOnChanged: (text) {
                  model.search(text);
                },
                isFilterShown: true,
                onTapFilter: () {
                  showCustomerFilterMenu(
                    context,
                    listPelangganMenu: model.tipePelangganOptions,
                    listSumberDataMenu: model.sumberDataOptions,
                    listTahapKonfirmasiMenu: model.tahapKonfirmasiOptions,
                    listSortMenu: model.sortOptions,
                    selectedPelanggan: model.selectedTipePelangganOption,
                    selectedSumberData: model.selectedSumberDataOption,
                    selectedTahapKonfirmasi:
                        model.selectedTahapKonfirmasiOption,
                    selectedSort: model.selectedSortOption,
                    terapkanCallback: model.terapkanFilter,
                  );
                },
              ),
              Spacings.vert(12),
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
                      title: "Nadia Ang",
                      description: "PT ABC JAYA",
                      desc2Size: 16,
                      titleSize: 20,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.detailCustomer);
                      },
                    );
                  },
                ),
              ),
              Spacings.vert(16),
            ],
          ),
        );
      },
    );
  }
}