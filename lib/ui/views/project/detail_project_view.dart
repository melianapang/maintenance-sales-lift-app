import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
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

class DetailProjectView extends StatefulWidget {
  const DetailProjectView({
    required this.profileData,
    super.key,
  });

  final ProfileData profileData;

  @override
  State<DetailProjectView> createState() => _DetailProjectViewState();
}

class _DetailProjectViewState extends State<DetailProjectView> {
  @override
  Widget build(BuildContext context) {
    final List<TimelineData> list1 = [
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
      TimelineData(
        date: "12 Maret 2021",
        note: "Butuh konfirmasi lagi.",
        onTap: () {
          Navigator.pushNamed(context, Routes.detailHistoryMaintenance);
        },
      ),
    ];

    return ViewModel(
      model: DetailProjectViewModel(),
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
                  Navigator.pushNamed(context, Routes.editProject);
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
          bottomNavigationBar: widget.profileData.role == Role.SuperAdmin
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
                    "KA-23243",
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
                    ),
                  ),
                  Spacings.vert(35),
                  StatusCardWidget(
                    cardType: StatusCardType.Defect,
                    onTap: () {},
                  ),
                  Spacings.vert(35),
                  TextInput.disabled(
                    label: "Lokasi",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "PIC",
                  ),
                  Spacings.vert(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Riwayat Pemeliharaan",
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.yellow01,
                        fontWeight: 400,
                      ),
                    ),
                  ),
                  TimelineWidget(
                    listTimeline: list1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
