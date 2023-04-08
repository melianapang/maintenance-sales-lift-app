import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_data.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/detail_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/timeline.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetailProjectViewParam {
  DetailProjectViewParam({
    this.projectData,
  });

  final ProjectData? projectData;
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
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailProjectViewModel(
        projectData: widget.param.projectData,
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
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editProject,
                  );
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
            ],
          ),
          bottomNavigationBar: model.isAllowedToDeleteData
              ? ButtonWidget.bottomSingleButton(
                  buttonType: ButtonType.primary,
                  padding: EdgeInsets.only(
                    bottom: PaddingUtils.getBottomPadding(
                      context,
                      defaultPadding: 12,
                    ),
                    left: 24.0,
                    right: 24.0,
                  ),
                  onTap: () {
                    showDialogWidget(
                      context,
                      title: "Menghapus Data Proyek",
                      description: "Anda yakin ingin menghapus Proyek ini?",
                      positiveLabel: "Iya",
                      negativeLabel: "Tidak",
                      positiveCallback: () async {
                        await Navigator.maybePop(context);

                        showDialogWidget(
                          context,
                          title: "Menghapus Data Proyek",
                          description: "Proyek telah dihapus.",
                          positiveLabel: "OK",
                          positiveCallback: () {
                            Navigator.maybePop(context);
                          },
                        );
                      },
                      negativeCallback: () {
                        Navigator.maybePop(context);
                      },
                    );
                  },
                  text: 'Hapus Proyek',
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.only(
              right: 24.0,
              bottom: 24.0,
              left: 24.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Spacings.vert(20),
                  Text(
                    "NAMA PROYEK",
                    style: buildTextStyle(
                      fontSize: 32,
                      fontWeight: 800,
                      fontColor: MyColors.yellow01,
                    ),
                  ),
                  Text(
                    "PT ABC JAYA",
                    style: buildTextStyle(
                      fontSize: 20,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                      isUnderlined: true,
                    ),
                  ),
                  Spacings.vert(35),
                  StatusCardWidget(
                    cardType: StatusCardType.Defect,
                    onTap: () {},
                  ),
                  Spacings.vert(35),
                  TextInput.disabled(
                    label: "Keperluan Proyek",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Alamat",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Kota",
                  ),
                  Spacings.vert(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PIC Proyek",
                      style: buildTextStyle(
                        fontSize: 14,
                        fontColor: MyColors.lightBlack02,
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
                          fontSize: 14,
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
                      itemCount: 5,
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
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 24.0,
                                top: 14,
                                bottom: 14,
                              ),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringUtils.removeZeroWidthSpaces("halo"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: buildTextStyle(
                                        fontColor: MyColors.lightBlack02,
                                        fontSize: 14,
                                        fontWeight: 800,
                                      ),
                                    ),
                                    Spacings.vert(2),
                                    Text(
                                      StringUtils.removeZeroWidthSpaces(
                                          "09098213972478"),
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
                            ),
                          ),
                        );
                      },
                    ),
                  Spacings.vert(24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
