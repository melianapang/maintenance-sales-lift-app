import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/detail_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/form_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/document_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/edit_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/project_location_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/form_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum DetailProjectSourcePage {
  ListProjectPage,
  DetailMaintenancePage,
}

class DetailProjectViewParam {
  DetailProjectViewParam({
    this.projectData,
    this.sourcePage,
  });

  final ProjectData? projectData;
  final DetailProjectSourcePage? sourcePage;
}

class DetailProjectView extends StatefulWidget {
  const DetailProjectView({
    required this.param,
    super.key,
  });

  final DetailProjectViewParam param;

  @override
  State<DetailProjectView> createState() => _DetailProjectViewState();
}

class _DetailProjectViewState extends State<DetailProjectView> {
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailProjectViewModel(
        projectData: widget.param.projectData,
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (DetailProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Data Proyek",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
            actions: widget.param.sourcePage ==
                    DetailProjectSourcePage.ListProjectPage
                ? <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.editProject,
                          arguments: EditProjectViewParam(
                            projectData: model.projectData,
                          ),
                        ).then((value) {
                          if (value == null) return;
                          if (value == true) {
                            model.refreshPage();
                            model.setPreviousPageNeedRefresh(true);

                            _handleErrorDialog(context, model);
                          }
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: Icon(
                          PhosphorIcons.pencilSimpleLineBold,
                          color: MyColors.lightBlack02,
                          size: 18,
                        ),
                      ),
                    ),
                  ]
                : null,
          ),
          floatingActionButton: _buildExtendedFAB(model),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 24.0,
              bottom: 24.0,
              left: 24.0,
            ),
            child: !model.busy
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Spacings.vert(20),
                        Text(
                          model.projectData?.projectName ?? "",
                          style: buildTextStyle(
                            fontSize: 30,
                            fontWeight: 800,
                            fontColor: MyColors.yellow01,
                          ),
                        ),
                        Text(
                          model.projectData?.customerName ?? "",
                          style: buildTextStyle(
                            fontSize: 20,
                            fontWeight: 400,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                        Spacings.vert(12),
                        StatusCardWidget(
                          cardType: model.statusCardType,
                          onTap: () {},
                        ),
                        Spacings.vert(35),
                        TextInput.disabled(
                          label: "Keperluan Proyek",
                          text: mappingProjectNeedTypeToString(
                            int.parse(model.projectData?.projectNeed ?? "0"),
                          ),
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Alamat",
                          text: model.projectData?.address,
                        ),
                        Spacings.vert(6),
                        _buildLihatLokasiProyek(model.projectData),
                        Spacings.vert(16),
                        TextInput.disabled(
                          label: "Kota",
                          text: model.projectData?.city,
                        ),
                        Spacings.vert(12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "PIC Proyek",
                            style: buildTextStyle(
                              fontSize: 18,
                              fontColor: MyColors.yellow01,
                              fontWeight: 700,
                            ),
                          ),
                        ),
                        Spacings.vert(12),
                        if (model.listPic.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Belum ada data PIC untuk proyek ini.",
                              style: buildTextStyle(
                                fontSize: 16,
                                fontColor: MyColors.lightBlack02.withOpacity(
                                  0.5,
                                ),
                                fontWeight: 300,
                              ),
                            ),
                          ),
                        if (model.listPic.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: model.projectData?.pics.length ?? 0,
                            separatorBuilder: (context, index) => const Divider(
                              color: MyColors.transparent,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 2,
                                color: MyColors.darkBlack02,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    19.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24.0,
                                    top: 14,
                                    bottom: 14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringUtils.removeZeroWidthSpaces(
                                          "${model.projectData?.pics[index].picName} - ${model.projectData?.pics[index].role}",
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: buildTextStyle(
                                          fontColor: MyColors.lightBlack02,
                                          fontSize: 16,
                                          fontWeight: 800,
                                        ),
                                      ),
                                      Spacings.vert(2),
                                      Text(
                                        StringUtils.removeZeroWidthSpaces(
                                          model.projectData?.pics[index]
                                                  .email ??
                                              "",
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: buildTextStyle(
                                          fontColor: MyColors.lightBlack02,
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                      ),
                                      Spacings.vert(2),
                                      Text(
                                        StringUtils.removeZeroWidthSpaces(
                                          model.projectData?.pics[index]
                                                  .phoneNumber ??
                                              "",
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: buildTextStyle(
                                          fontColor: MyColors.lightBlack02,
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        Spacings.vert(24),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      buildLoadingPage(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLihatLokasiProyek(ProjectData? projectData) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.projectLocation,
          arguments: ProjectLocationViewParam(
            projectData: projectData,
          ),
        ),
        child: Text(
          "Lihat Lokasi Proyek",
          style: buildTextStyle(
            fontSize: 14,
            fontColor: MyColors.blueLihatSelengkapnya,
            fontWeight: 500,
            isUnderlined: true,
          ),
        ),
      ),
    );
  }

  Widget _buildExtendedFAB(DetailProjectViewModel model) {
    return SpeedDial(
      icon: PhosphorIcons.plusBold,
      activeIcon: PhosphorIcons.xBold,
      spacing: 3,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      dialRoot: (ctx, open, toggleChildren) {
        return FloatingButtonWidget(
          onTap: toggleChildren,
          icon: PhosphorIcons.squaresFourBold,
        );
      },
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(52.0, 52.0),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      renderOverlay: false,
      useRotationAnimation: true,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      children: [
        SpeedDialChild(
          child: !model.isDialChildrenVisible
              ? const Icon(PhosphorIcons.listBulletsBold)
              : null,
          backgroundColor: MyColors.yellow02,
          foregroundColor: MyColors.white,
          label: 'Dokumen Proyek',
          labelBackgroundColor: MyColors.lightBlack01,
          labelShadow: [
            const BoxShadow(
              color: MyColors.transparent,
            ),
          ],
          labelStyle: buildTextStyle(
              fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.documentProject,
              arguments: DocumentProjectViewwParam(
                projectData: model.projectData,
              ),
            );

            setState() {
              model.setDialChildrenVisible();
            }
          },
        ),
        if (widget.param.sourcePage == DetailProjectSourcePage.ListProjectPage)
          SpeedDialChild(
            child: !model.isDialChildrenVisible
                ? const Icon(PhosphorIcons.listBulletsBold)
                : null,
            backgroundColor: MyColors.yellow02,
            foregroundColor: MyColors.white,
            label: 'Daftar Unit Proyek',
            labelBackgroundColor: MyColors.lightBlack01,
            labelShadow: [
              const BoxShadow(
                color: MyColors.transparent,
              ),
            ],
            labelStyle: buildTextStyle(
                fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.listUnit,
                arguments: ListUnitCustomerViewParam(
                  sourcePage: ListUnitCustomerSourcePage.DetailProject,
                  customerData: model.customerData,
                  projectData: model.projectData,
                ),
              );

              setState() {
                model.setDialChildrenVisible();
              }
            },
          ),
        if (widget.param.sourcePage ==
            DetailProjectSourcePage.ListProjectPage) ...[
          if (model.isAllowedToDeleteData)
            SpeedDialChild(
              child: !model.isDialChildrenVisible
                  ? const Icon(PhosphorIcons.trashBold)
                  : null,
              backgroundColor: MyColors.yellow02,
              foregroundColor: MyColors.white,
              label: 'Hapus Data Proyek',
              labelBackgroundColor: MyColors.lightBlack01,
              labelShadow: [
                const BoxShadow(
                  color: MyColors.transparent,
                ),
              ],
              labelStyle: buildTextStyle(
                  fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
              onTap: () {
                showDialogWidget(
                  context,
                  title: "Menghapus Data Proyek",
                  description: "Anda yakin ingin menghapus Proyek ini?",
                  positiveLabel: "Iya",
                  negativeLabel: "Tidak",
                  positiveCallback: () async {
                    await Navigator.maybePop(context);

                    buildLoadingDialog(context);
                    bool result = await model.requestDeleteProject();
                    Navigator.pop(context);

                    showDialogWidget(
                      context,
                      title: "Menghapus Data Proyek",
                      isSuccessDialog: result,
                      description: result
                          ? "Proyek telah dihapus."
                          : model.errorMsg ??
                              "Proyek gagal dihapus. Coba beberapa saat lagi.",
                      positiveLabel: "OK",
                      positiveCallback: () {
                        if (result) {
                          Navigator.of(context)
                            ..pop()
                            ..pop(true);
                          return;
                        }

                        model.resetErrorMsg();
                        Navigator.maybePop(context);
                      },
                    );
                  },
                  negativeCallback: () {
                    Navigator.maybePop(context);
                  },
                );

                setState() {
                  model.setDialChildrenVisible();
                }
              },
            ),
          SpeedDialChild(
            child: !model.isDialChildrenVisible
                ? const Icon(PhosphorIcons.bellBold)
                : null,
            backgroundColor: MyColors.yellow02,
            foregroundColor: MyColors.white,
            label: 'Jadwalkan Pengingat',
            labelBackgroundColor: MyColors.lightBlack01,
            labelShadow: [
              const BoxShadow(
                color: MyColors.transparent,
              ),
            ],
            labelStyle: buildTextStyle(
                fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.formSetReminder,
                arguments: FormSetReminderViewParam(
                  source: FormSetReminderSource.ProjectPage,
                  projectData: widget.param.projectData,
                ),
              );

              setState() {
                model.setDialChildrenVisible();
              }
            },
          ),
          SpeedDialChild(
            child: !model.isDialChildrenVisible
                ? const Icon(PhosphorIcons.newspaperClippingBold)
                : null,
            backgroundColor: MyColors.yellow02,
            foregroundColor: MyColors.white,
            label: 'Buat Laporan Konfirmasi',
            labelBackgroundColor: MyColors.lightBlack01,
            labelShadow: [
              const BoxShadow(
                color: MyColors.transparent,
              ),
            ],
            labelStyle: buildTextStyle(
                fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
            onTap: () async {
              Navigator.pushNamed(
                context,
                Routes.formFollowUp,
                arguments: FormFollowUpViewParam(
                  projectData: model.projectData,
                ),
              );

              setState() {
                model.setDialChildrenVisible();
              }
            },
          ),
        ],
      ],
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    DetailProjectViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Riwayat Konfirmasi",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Riwayat. \n Coba beberappa saat lagi.",
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
