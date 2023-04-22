import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/user/detail_user_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/edit_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetailUserViewParam {
  DetailUserViewParam({
    this.userData,
  });

  UserData? userData;
}

class DetailUserView extends StatefulWidget {
  const DetailUserView({
    required this.param,
    super.key,
  });

  final DetailUserViewParam param;

  @override
  State<DetailUserView> createState() => _DetailUserViewState();
}

class _DetailUserViewState extends State<DetailUserView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailUserViewModel(
        userData: widget.param.userData,
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (DetailUserViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Data User",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editUser,
                    arguments: EditUserViewParam(
                      userData: model.userData,
                    ),
                  ).then((value) {
                    if (value == null || value == false) return;

                    model.requestGetDetailCustomer();
                    model.setPreviousPageNeedRefresh(true);
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
            ],
          ),
          bottomNavigationBar: model.isAllowedToDeleteUser
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
                      title: "Menghapus Data User",
                      description: "Anda yakin ingin menghapus User ini?",
                      positiveLabel: "Iya",
                      negativeLabel: "Tidak",
                      positiveCallback: () async {
                        bool isSucceed = await model.requestDeleteUser();
                        await Navigator.maybePop(context);

                        showDialogWidget(
                          context,
                          title: "Menghapus Data User",
                          isSuccessDialog: isSucceed,
                          description: isSucceed
                              ? "User telah dihapus."
                              : "User gagal dihapus. \n ${model.errorMsg}.",
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
                  text: 'Hapus User',
                )
              : null,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ),
            child: Column(
              children: [
                TextInput.disabled(
                  label: "Nama User",
                  text: model.userData?.name,
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Username",
                  text: model.userData?.username,
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Peran",
                  text: StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                    model.userData?.roleName ?? "",
                  ),
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Alamat",
                  text: model.userData?.address,
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Kota",
                  text: model.userData?.city,
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "No Telepon",
                  text: model.userData?.phoneNumber,
                ),
                Spacings.vert(24),
                TextInput.disabled(
                  label: "Email",
                  text: model.userData?.email,
                ),
                Spacings.vert(24),
              ],
            ),
          ),
        );
      },
    );
  }
}
