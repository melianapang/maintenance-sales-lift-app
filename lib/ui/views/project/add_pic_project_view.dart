import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/project/add_pic_project_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddPicProjectViewParam {
  AddPicProjectViewParam({
    this.listRole,
  });

  final List<String>? listRole;
}

class AddPicProjectView extends StatefulWidget {
  const AddPicProjectView({
    required this.param,
    super.key,
  });

  final AddPicProjectViewParam param;

  @override
  State<AddPicProjectView> createState() => _AddPicProjectViewState();
}

class _AddPicProjectViewState extends State<AddPicProjectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: AddPicProjectViewModel(
        listRole: widget.param.listRole,
      ),
      onModelReady: (AddPicProjectViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Tambah PIC Proyek",
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
              model.sendDataBack(context);
            },
            text: 'Tambahkan PIC',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInput.editable(
                  label: "Nama PIC",
                  controller: model.namaPicController,
                  onChangedListener: model.onChangedName,
                  hintText: "Nama PIC Proyek",
                  errorText: model.isNameValid == false
                      ? "Wajib diisi dengan benar menggunakan huruf"
                      : null,
                ),
                Spacings.vert(24),
                GestureDetector(
                  onTap: () {
                    _showAddableBottomDialog(
                      context,
                      model,
                      setSelectedRole: model.setSelectedRole,
                    );
                  },
                  child: TextInput.disabled(
                    label: "Peran PIC",
                    text: model.selectedRole,
                    hintText: "Pilih Peran untuk PIC ini",
                    suffixIcon: const Icon(
                      PhosphorIcons.caretDownBold,
                      color: MyColors.lightBlack02,
                    ),
                  ),
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Email PIC",
                  controller: model.emailController,
                  hintText: "Email PIC",
                  keyboardType: TextInputType.emailAddress,
                  errorText: model.isEmailValid == false
                      ? "Wajib diisi dengan benar"
                      : null,
                  onChangedListener: model.onChangedEmail,
                ),
                Spacings.vert(24),
                TextInput.editable(
                  label: "Nomor Telepon PIC",
                  controller: model.phoneNumberController,
                  hintText: "Nomor Telepon PIC",
                  keyboardType: TextInputType.phone,
                  errorText: model.isPhoneNumberValid == false
                      ? "Wajib diisi dengan benar menggunakan angka"
                      : null,
                  onChangedListener: model.onChangedPhoneNumber,
                ),
                Spacings.vert(24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddableBottomDialog(
    BuildContext context,
    AddPicProjectViewModel model, {
    required void Function({
      required String selectedRole,
    })
        setSelectedRole,
  }) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Peran PIC',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: Expanded(
        child: StatefulBuilder(
          builder: (context, ss) {
            return FutureBuilder<List<String>>(
              future: model.searchOnChanged(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    buildSearchBarAndAddableMenu(
                      context,
                      isShowingAddableMenu:
                          model.listSearchedRole?.isEmpty == true,
                      searchController: model.searchController,
                      textSearchOnChanged: (_) {
                        model.isSearch = true;
                        ss(() {});
                      },
                      onTapFilter: () {
                        String role =
                            StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                          model.searchController.text,
                        );
                        model.listRole?.add(role);
                        setSelectedRole(selectedRole: role);
                        model.searchController.text = "";
                        Navigator.maybePop(context);
                      },
                    ),
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data?.isNotEmpty == true)
                      Text(
                        "Jika tidak ada data yang sesuai, silahkan tambahkan data dengan klik tombol (+) disamping pencarian.",
                        textAlign: TextAlign.center,
                        style: buildTextStyle(
                          fontSize: 14,
                          fontColor: MyColors.lightBlack02,
                          fontWeight: 400,
                        ),
                      ),
                    snapshot.connectionState == ConnectionState.done
                        ? snapshot.data?.isNotEmpty == true
                            ? Expanded(
                                child: ListView.separated(
                                  itemCount: snapshot.data?.length ?? 0,
                                  separatorBuilder: (_, __) => const Divider(
                                    color: MyColors.transparent,
                                    height: 20,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CustomCardWidget(
                                      cardType: CardType.list,
                                      title: snapshot.data?[index] ?? "",
                                      titleSize: 20,
                                      onTap: () {
                                        setSelectedRole(
                                          selectedRole:
                                              snapshot.data?[index] ?? "",
                                        );
                                        Navigator.maybePop(context);
                                      },
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  "Tidak ada data yang sesuai, silahkan tambahkan data Peran dengan klik tombol (+) disamping pencarian.",
                                  textAlign: TextAlign.center,
                                  style: buildTextStyle(
                                    fontSize: 16,
                                    fontColor: MyColors.lightBlack02,
                                    fontWeight: 600,
                                  ),
                                ),
                              )
                        : Column(
                            children: [
                              buildLoadingPage(),
                            ],
                          )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
