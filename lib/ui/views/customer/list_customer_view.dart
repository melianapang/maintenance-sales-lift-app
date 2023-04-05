import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/list_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/detail_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListCustomerView extends StatefulWidget {
  const ListCustomerView({
    super.key,
  });

  @override
  State<ListCustomerView> createState() => _ListCustomerViewState();
}

class _ListCustomerViewState extends State<ListCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<ListCustomerViewModel>(
      model: ListCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (ListCustomerViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.addCustomer);
            },
          ),
          appBar: buildDefaultAppBar(
            context,
            title: "Pelanggan",
            isBackEnabled: true,
            actions: <Widget>[
              if (model.isAllowedToExportData)
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
                isEnabled: !model.busy && !model.isShowNoDataFoundPage,
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
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.requestGetAllCustomer(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.listCustomer?.length ?? 0,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: model.listCustomer?[index].customerName ?? "",
                          description: model.listCustomer?[index].companyName,
                          desc2Size: 16,
                          titleSize: 20,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailCustomer,
                              arguments: DetailCustomerViewParam(
                                customerData: model.listCustomer?[index],
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
