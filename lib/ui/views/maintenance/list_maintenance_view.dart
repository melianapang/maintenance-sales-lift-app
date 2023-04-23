import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/list_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
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
      model: ListMaintenanceViewModel(
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (ListMaintenanceViewModel model) async {
        await model.initModel();

        if (model.errorMsg != null)
          _buildErrorDialog(
            context,
            model,
          );
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Jadwal Pemeliharaan",
            isBackEnabled: true,
            actions: <Widget>[
              if (model.isAllowedToExportData)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.exportMaintenance,
                    );
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
                isEnabled: !model.isShowNoDataFoundPage ||
                    model.searchController.text.isNotEmpty,
                textSearchOnChanged: model.searchOnChanged,
                searchController: model.searchController,
                isFilterShown: true,
                onTapFilter: () {
                  showMaintenanceFilterMenu(
                    context,
                    listMaintenanceStatusMenu: model.maintenanceStatusOptions,
                    listSortMenu: model.sortOptions,
                    selectedMaintenanceStatus:
                        model.selectedMaintenanceStatusOption,
                    selectedSort: model.selectedSortOption,
                    terapkanCallback: model.terapkanFilter,
                  );
                },
              ),
              Spacings.vert(12),
              if (!model.isShowNoDataFoundPage &&
                  !model.busy &&
                  !model.isLoading)
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.onLazyLoad(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: model.listMaintenance?.length ?? 0,
                        separatorBuilder: (context, index) => const Divider(
                              color: MyColors.transparent,
                              height: 20,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCardWidget(
                            cardType: CardType.list,
                            title: model.listMaintenance?[index].unitName ?? "",
                            description:
                                "${model.listMaintenance?[index].companyName} ${model.listMaintenance?[index].companyName != null ? "|" : ""} ${model.listMaintenance?[index].customerName}",
                            description2: DateTimeUtils
                                .convertStringToOtherStringDateFormat(
                                    date: model.listMaintenance?[index]
                                            .scheduleDate ??
                                        DateTimeUtils.convertDateToString(
                                          date: DateTime.now(),
                                          formatter: DateFormat(
                                            DateTimeUtils.DATE_FORMAT_2,
                                          ),
                                        ),
                                    formattedString:
                                        DateTimeUtils.DATE_FORMAT_2),
                            titleSize: 20,
                            descSize: 16,
                            desc2Size: 12,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.detailMaintenance,
                                arguments: DetailMaintenanceViewParam(
                                  maintenanceData:
                                      model.listMaintenance?[index],
                                ),
                              ).then((value) {
                                if (value == null) return;
                                if (value == true) {
                                  model.refreshPage();
                                }
                              });
                            },
                          );
                        }),
                  ),
                ),
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

  void _buildErrorDialog(
    BuildContext context,
    ListMaintenanceViewModel model,
  ) {
    showDialogWidget(
      context,
      title: "Daftar Pemeliharaan",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Pemeliharaan. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.refreshPage();
        Navigator.pop(context);

        if (model.errorMsg != null) _buildErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
