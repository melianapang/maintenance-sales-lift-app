import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/reminders/list_reminder_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/detail_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/form_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class ListRemindersView extends StatefulWidget {
  const ListRemindersView({super.key});

  @override
  State<ListRemindersView> createState() => _ListRemindersViewState();
}

class _ListRemindersViewState extends State<ListRemindersView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListReminderViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListReminderViewModel model) async {
        await model.initModel();

        _handleErrorDialog(
          context,
          model,
        );
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Pengingat",
            isBackEnabled: true,
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.formSetReminder,
                arguments: FormSetReminderViewParam(
                  source: FormSetReminderSource.ListReminderPage,
                ),
              ).then((value) {
                if (value == null) return;
                if (value == true) {
                  model.refreshPage();
                }
              });
            },
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
                isFilterShown: false,
                onTapFilter: () {},
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
                      itemCount: model.listReminder.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: model.listReminder[index].projectName ??
                              "(Tanpa Proyek)",
                          description: model.listReminder[index].description,
                          description2: DateTimeUtils
                              .convertStringToOtherStringDateFormat(
                            date: model.listReminder[index].reminderDate,
                            formattedString: DateTimeUtils.DATE_FORMAT_2,
                          ),
                          titleSize: 20,
                          descSize: 16,
                          desc2Size: 12,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailReminder,
                              arguments: DetailReminderViewParam(
                                reminderData: model.listReminder[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              Spacings.vert(24),
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
    ListReminderViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Pengingat",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Pengingat. \n Coba beberappa saat lagi.",
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
