import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/log/list_log_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/log/detail_log_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:intl/intl.dart';

class ListLogView extends StatefulWidget {
  const ListLogView({super.key});

  @override
  State<ListLogView> createState() => _ListLogViewState();
}

class _ListLogViewState extends State<ListLogView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListLogViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListLogViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Log",
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
              if (!model.isShowNoDataFoundPage && !model.busy) ...[
                Spacings.vert(12),
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () => model.requestGetAllLog(),
                    scrollDirection: Axis.vertical,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: model.listLogData?.length ?? 0,
                        separatorBuilder: (context, index) => const Divider(
                              color: MyColors.transparent,
                              height: 20,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCardWidget(
                            cardType: CardType.list,
                            title: StringUtils
                                .replaceUnderscoreToSpaceAndTitleCase(
                                    model.listLogData?[index].tableName ?? ""),
                            description:
                                "Diubah oleh: ${model.listLogData?[index].userName}",
                            description2: DateTimeUtils
                                .convertStringToOtherStringDateFormat(
                              date: model.listLogData?[index].createdAt ??
                                  DateTimeUtils.convertDateToString(
                                    date: DateTime.now(),
                                    formatter: DateFormat(
                                      DateTimeUtils.DATE_FORMAT_2,
                                    ),
                                  ),
                              formattedString: DateTimeUtils.DATE_FORMAT_2,
                            ),
                            titleSize: 20,
                            descSize: 16,
                            desc2Size: 12,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.detailLog,
                                arguments: DetailLogViewParam(
                                  logData: model.listLogData?[index],
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ),
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
