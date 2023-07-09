import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/list_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/detail_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class ListProjectView extends StatefulWidget {
  const ListProjectView({
    super.key,
  });

  @override
  State<ListProjectView> createState() => _ListProjectViewState();
}

class _ListProjectViewState extends State<ListProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListProjectViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListProjectViewModel model) async {
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
            title: "Proyek",
            isBackEnabled: true,
          ),
          floatingActionButton: FloatingButtonWidget(
            onTap: () {
              Navigator.pushNamed(context, Routes.addProject).then((value) {
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
                      itemCount: model.listProject.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: MyColors.transparent,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildProjectCard(
                          projectData: model.listProject[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailProject,
                              arguments: DetailProjectViewParam(
                                projectData: model.listProject[index],
                                sourcePage:
                                    DetailProjectSourcePage.ListProjectPage,
                              ),
                            ).then(
                              (value) {
                                if (value == null) return;
                                if (value == true) {
                                  model.refreshPage();
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

  Widget _buildProjectCard({
    required ProjectData projectData,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 2,
        color: projectData.isBgRed == true
            ? MyColors.redBackgroundMaintenanceCard
            : MyColors.darkBlack02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            19.0,
          ),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              top: 14,
              bottom: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        StringUtils.removeZeroWidthSpaces(
                          projectData.projectName,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: buildTextStyle(
                          fontColor: projectData.isBgRed == true
                              ? MyColors.white
                              : MyColors.lightBlack02,
                          fontSize: 20,
                          fontWeight: 800,
                        ),
                      ),
                      Spacings.vert(2),
                      Text(
                        StringUtils.removeZeroWidthSpaces(projectData
                                        .companyName !=
                                    null ||
                                projectData.companyName?.isNotEmpty == true
                            ? "${projectData.companyName} | ${projectData.customerName}"
                            : projectData.customerName),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: buildTextStyle(
                          fontColor: projectData.isBgRed == true
                              ? MyColors.white
                              : MyColors.lightBlack02,
                          fontSize: 16,
                          fontWeight: 400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    ListProjectViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Proyek",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Proyek. \n Coba beberappa saat lagi.",
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
