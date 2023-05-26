import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/list_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/detail_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class ListUserView extends StatefulWidget {
  const ListUserView({super.key});

  @override
  State<ListUserView> createState() => _ListUserViewState();
}

class _ListUserViewState extends State<ListUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListUserViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListUserViewModel model) async {
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
            title: "User",
            isBackEnabled: true,
          ),
          floatingActionButton: FloatingButtonWidget(onTap: () {
            Navigator.pushNamed(
              context,
              Routes.addUser,
            ).then(
              (value) {
                if (value == null) return;
                if (value == true) {
                  model.refreshPage();
                }
              },
            );
          }),
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
                onTapFilter: () => showUserFilterMenu(
                  context,
                  listRole: model.roleOptions,
                  selectedRole: model.selectedRoleOption,
                  terapkanCallback: model.terapkanFilter,
                ),
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
                      itemCount: model.listUser.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CustomCardWidget(
                          cardType: CardType.list,
                          title: StringUtils.removeZeroWidthSpaces(
                            model.listUser[index].name,
                          ),
                          description:
                              StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                            model.listUser[index].roleName,
                          ),
                          descSize: 16,
                          titleSize: 20,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailUser,
                              arguments: DetailUserViewParam(
                                userData: model.listUser[index],
                              ),
                            ).then(
                              (value) async {
                                if (value == null) return;
                                if (value == true) {
                                  await model.refreshPage();

                                  _handleErrorDialog(context, model);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
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

  void _handleErrorDialog(
    BuildContext context,
    ListUserViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Pengguna",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar pengguna. \n Coba beberappa saat lagi.",
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
