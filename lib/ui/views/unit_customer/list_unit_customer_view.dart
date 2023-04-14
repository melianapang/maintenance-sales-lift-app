import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/list_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/detail_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListUnitCustomerViewParam {
  ListUnitCustomerViewParam({
    this.customerData,
  });

  final CustomerData? customerData;
}

class ListUnitCustomerView extends StatefulWidget {
  const ListUnitCustomerView({
    required this.param,
    super.key,
  });

  final ListUnitCustomerViewParam param;

  @override
  State<ListUnitCustomerView> createState() => _ListUnitCustomerViewState();
}

class _ListUnitCustomerViewState extends State<ListUnitCustomerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<ListUnitCustomerViewModel>(
      model: ListUnitCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        customerData: widget.param.customerData,
      ),
      onModelReady: (ListUnitCustomerViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.addUnit);
            },
          ),
          appBar: buildDefaultAppBar(
            context,
            title: "Unit",
            isBackEnabled: true,
          ),
          body: Column(
            children: [
              Spacings.vert(24),
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.requestGetAllUnit(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.listUnit?.length ?? 0,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: model.listUnit?[index].unitName ?? "",
                          description: model.listUnit?[index].unitLocation,
                          desc2Size: 16,
                          titleSize: 20,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailUnit,
                              arguments: DetailUnitCustomerViewParam(
                                unitData: model.listUnit?[index],
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
