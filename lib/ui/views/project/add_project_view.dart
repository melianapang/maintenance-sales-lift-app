import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/add_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import 'add_pic_project_view.dart';

class AddProjectView extends StatefulWidget {
  const AddProjectView({super.key});

  @override
  State<AddProjectView> createState() => _AddProjectViewState();
}

class _AddProjectViewState extends State<AddProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddProjectViewModel(),
      onModelReady: (AddProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah Proyek",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
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
              Navigator.maybePop(context);
            },
            text: 'Simpan',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Nama Proyek",
                  hintText: "Nama Proyek",
                ),
                Spacings.vert(24),
                GestureDetector(
                  onTap: () {
                    _showKeperluanProyekBottomDialog(
                      context,
                      model,
                      listMenu: model.keperluanProyekOptions,
                      selectedMenu: model.selectedKeperluanProyekOption,
                      setSelectedMenu: model.setSelectedKeperluanProyek,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Keperluan Proyek",
                    text: model.keperluanProyekOptions
                        .where((element) => element.isSelected)
                        .first
                        .title,
                    suffixIcon: const Icon(
                      PhosphorIcons.caretDownBold,
                      color: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Alamat",
                  hintText: "Alamat Proyek",
                ),
                Spacings.vert(24),
                TextInput.editable(
                  onChangedListener: (text) {},
                  label: "Kota",
                  hintText: "Kota",
                ),
                Spacings.vert(24),
                Text(
                  "PIC Proyek",
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02,
                  ),
                ),
                Spacings.vert(12),
                if (model.listPic.isEmpty)
                  Text(
                    "Belum ada data PIC untuk proyek ini.",
                    style: buildTextStyle(
                      fontSize: 14,
                      fontColor: MyColors.lightBlack02.withOpacity(
                        0.5,
                      ),
                      fontWeight: 300,
                    ),
                  ),
                if (model.listPic.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: model.listPic.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: MyColors.transparent,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CustomCardWidget(
                        cardType: CardType.list,
                        title: model.listPic[index].name,
                        description: model.listPic[index].phoneNumber,
                        desc2Size: 12,
                        titleSize: 14,
                        icon: PhosphorIcons.trashBold,
                        onTap: () {
                          model.deletePicProject(index);
                        },
                      );
                    },
                  ),
                Spacings.vert(12),
                GestureDetector(
                  onTap: () => _awaitAddPicProjectViewResult(
                    context,
                    viewModel: model,
                  ),
                  child: Text(
                    'Tambahkan PIC Proyek',
                    textAlign: TextAlign.start,
                    style: buildTextStyle(
                      fontSize: 12,
                      fontWeight: 400,
                      fontColor: MyColors.blueLihatSelengkapnya,
                      isUnderlined: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showKeperluanProyekBottomDialog(
    BuildContext context,
    AddProjectViewModel model, {
    required List<FilterOption> listMenu,
    required int selectedMenu,
    required void Function({
      required int selectedMenu,
    })
        setSelectedMenu,
  }) {
    final List<FilterOption> menuLocal = convertToNewList(listMenu);
    int menu = selectedMenu;

    showGeneralBottomSheet(
      context: context,
      title: 'Kebutuhan Pelanggan',
      isFlexible: true,
      showCloseButton: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMenuChoices(
                menuLocal,
                (int selectedIndex) {
                  menu = selectedIndex;
                  for (int i = 0; i < menuLocal.length; i++) {
                    if (i == selectedIndex) {
                      menuLocal[i].isSelected = true;
                      continue;
                    }

                    menuLocal[i].isSelected = false;
                  }
                  setState(() {});
                },
              ),
              Spacings.vert(32),
              ButtonWidget(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.large,
                text: "Terapkan",
                onTap: () {
                  setSelectedMenu(
                    selectedMenu: menu,
                  );
                  Navigator.maybePop(context);
                },
              )
            ],
          );
        },
      ),
    );
  }

  void _awaitAddPicProjectViewResult(
    BuildContext context, {
    required AddProjectViewModel viewModel,
  }) async {
    final result = await Navigator.pushNamed(context, Routes.addPicProject);
    setState(() {
      viewModel.addPicProject(result as PicData);
    });
  }
}
