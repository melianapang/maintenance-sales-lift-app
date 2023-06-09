import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/non_project_customer/list_non_project_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/non_project_customer/detail_non_project_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListNonProjectCustomerView extends StatefulWidget {
  const ListNonProjectCustomerView({
    super.key,
  });

  @override
  State<ListNonProjectCustomerView> createState() =>
      _ListNonProjectCustomerViewState();
}

class _ListNonProjectCustomerViewState
    extends State<ListNonProjectCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<ListNonProjectCustomerViewModel>(
      model: ListNonProjectCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (ListNonProjectCustomerViewModel model) async {
        await model.initModel();

        _handleErrorDialog(
          context,
          model,
        );
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.addNonProjectCustomer,
              ).then((value) {
                if (value == null) return;
                if (value == true) {
                  model.refreshPage();
                }
              });
            },
          ),
          appBar: buildDefaultAppBar(
            context,
            title: "Pelanggan Tanpa Proyek",
            isBackEnabled: true,
          ),
          body: Column(
            children: [
              buildSearchBar(
                context,
                isEnabled: !(model.isShowNoDataFoundPage &&
                    model.searchController.text.isEmpty),
                textSearchOnChanged: (_) async {
                  await model.searchOnChanged();

                  _handleErrorDialog(
                    context,
                    model,
                  );
                },
                searchController: model.searchController,
                isFilterShown: true,
                onTapFilter: () {
                  showCustomerFilterMenu(
                    context,
                    listPelangganMenu: model.customerTypeFilterOptions,
                    listSumberDataMenu: model.sumberDataOptions,
                    listKebutuhanPelanggan: model.customerNeedFilterOptions,
                    listSortMenu: model.sortOptions,
                    selectedPelanggan: model.selectedCustomerTypeFilter,
                    selectedSumberData: model.selectedSumberDataOption,
                    selectedKebutuhanPelanggan:
                        model.selectedCustomerNeedFilter,
                    selectedSort: model.selectedSortOption,
                    terapkanCallback: model.terapkanFilter,
                  );
                },
              ),
              Spacings.vert(12),
              if (!model.isShowNoDataFoundPage &&
                  !model.busy &&
                  !model.isLoading) ...[
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.onLazyLoad(),
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
                              Routes.detailNonProjectCustomer,
                              arguments: DetailNonProjectCustomerViewParam(
                                customerData: model.listCustomer?[index],
                              ),
                            ).then((value) {
                              if (value == null) return;
                              if (value == true) {
                                model.refreshPage();
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                Spacings.vert(16),
              ],
              if (model.isShowNoDataFoundPage &&
                  !model.busy &&
                  !model.isLoading)
                buildNoDataFoundPage(),
              if (model.busy || model.isLoading) buildLoadingPage(),
            ],
          ),
        );
      },
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    ListNonProjectCustomerViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Pelanggan Non-Proyek",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Pelanggan. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.refreshPage();
        Navigator.pop(context);

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
