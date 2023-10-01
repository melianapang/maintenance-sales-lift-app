import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/choose_customer_bottom_sheet/choose_customer_bottom_sheet_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ChooseCustomerBottomSheet extends StatelessWidget {
  const ChooseCustomerBottomSheet({
    required this.selectedCustomerCallback,
    super.key,
  });

  final void Function(CustomerData?) selectedCustomerCallback;

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ChooseCustomerBottomSheetViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ChooseCustomerBottomSheetViewModel model) {
        model.initModel();
      },
      builder: (context, model, child) {
        return Column(
          children: [
            buildSearchBar(
              context,
              isFilterShown: false,
              searchController: model.searchController,
              textSearchOnChanged: (_) {
                model.searchCustomer();
                // model.isSearch = true;
                //ss(() {});
              },
            ),
            if (!model.isShowNoDataFoundPage && !model.busy)
              Expanded(
                child: LazyLoadScrollView(
                  onEndOfPage: () {
                    model.searchCustomer();
                    // model.isSearch = false;
                    // ss(() {});
                  },
                  child: ListView.separated(
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
                          selectedCustomerCallback(model.listCustomer?[index]);
                          model.setSelectedCustomer(index);
                          Navigator.maybePop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
            if (model.isShowNoDataFoundPage && !model.busy)
              buildNoDataFoundPage(),
            if (model.busy) buildLoadingPage(),
          ],
        );
      },
    );
  }
}
