import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/home_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/manage_profile_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/home_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/manage_account/edit_profile_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import '../../core/app_constants/colors.dart';
import '../../core/models/profile/profile_data_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: HomeViewModel(
        dioService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
        sharedPreferencesService:
            Provider.of<SharedPreferencesService>(context),
      ),
      onModelReady: (HomeViewModel model) async {
        await model.initModel();
        if (model.profileData == null)
          Navigator.pushReplacementNamed(
            context,
            Routes.login,
          );
      },
      builder: (context, model, child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: MyColors.darkBlack01,
          body: !model.busy
              ? Padding(
                  padding: PaddingUtils.getPadding(context, defaultPadding: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacings.vert(12),
                        _buildProfileCard(model.profileData),
                        Spacings.vert(32),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Menu Utama",
                            style: buildTextStyle(
                              fontSize: 24,
                              fontColor: MyColors.yellow01,
                              fontWeight: 300,
                            ),
                          ),
                        ),
                        _buildGridListMenu(
                          model.getUserMenu(),
                          true,
                          model,
                        ),
                        if (model.profileData?.role == Role.Admin ||
                            model.profileData?.role == Role.SuperAdmin) ...[
                          Spacings.vert(24),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sales',
                              style: buildTextStyle(
                                fontSize: 18,
                                fontColor: MyColors.yellow01,
                                fontWeight: 300,
                              ),
                            ),
                          ),
                          _buildGridListMenu(
                            homeMenu
                                .where((element) =>
                                    element.role.contains(Role.Sales) &&
                                    !element.role.contains(Role.Admin))
                                .toList(),
                            false,
                            null,
                          ),
                          Spacings.vert(24),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Maintenance',
                              style: buildTextStyle(
                                fontSize: 18,
                                fontColor: MyColors.yellow01,
                                fontWeight: 300,
                              ),
                            ),
                          ),
                          _buildGridListMenu(
                            homeMenu
                                .where((element) =>
                                    element.role.contains(Role.Engineers) &&
                                    !element.role.contains(Role.Admin))
                                .toList(),
                            false,
                            null,
                          ),
                        ],
                        Spacings.vert(32),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Kelola Akun",
                            style: buildTextStyle(
                              fontSize: 24,
                              fontWeight: 300,
                              fontColor: MyColors.yellow01,
                            ),
                          ),
                        ),
                        GridView.builder(
                          padding: const EdgeInsets.only(
                            top: 18,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: manageProfileMenu.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 130,
                          ),
                          itemBuilder: (context, index) {
                            return CustomCardWidget(
                              cardType: CardType.menu,
                              title: manageProfileMenu[index].title,
                              titleSize: 12,
                              icon: manageProfileMenu[index].icon,
                              onTap: () {
                                if (manageProfileMenu[index].callback != null) {
                                  showDialogWidget(
                                    context,
                                    title: 'Keluar',
                                    description: 'Anda yakin ingin Keluar?',
                                    positiveLabel: "Iya",
                                    negativeLabel: "Tidak",
                                    positiveCallback: () async {
                                      buildLoadingDialog(context);
                                      await model.logout();
                                    },
                                    negativeCallback: () {
                                      Navigator.maybePop(context);
                                    },
                                  );
                                } else if (manageProfileMenu[index].route !=
                                    null) {
                                  Navigator.pushNamed(
                                      context,
                                      manageProfileMenu[index].route ??
                                          Routes.home);
                                } else {
                                  null;
                                }
                              },
                            );
                          },
                        ),
                        Spacings.vert(14),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "App Version: ${model.packageInfo?.version ?? "1.0.0"}",
                            textAlign: TextAlign.center,
                            style: buildTextStyle(
                              fontSize: 14,
                              fontColor: MyColors.darkBlack02,
                              fontWeight: 400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    buildLoadingPage(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildProfileCard(ProfileData? userData) {
    return Card(
        elevation: 2,
        shadowColor: MyColors.darkBlack02,
        color: MyColors.darkBlack02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringUtils.removeZeroWidthSpaces(
                        "Halo, ${userData?.username ?? ""}!",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: buildTextStyle(
                        fontSize: 20,
                        fontWeight: 700,
                        fontColor: MyColors.yellow01,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.userGearBold,
                          size: 14,
                          color: MyColors.lightBlack02,
                        ),
                        Spacings.horz(6),
                        Text(
                          StringUtils.removeZeroWidthSpaces(
                            mappingRoleToString(
                              userData?.role ?? Role.Engineers,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: buildTextStyle(
                            fontSize: 14,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacings.horz(10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editProfile,
                    arguments: EditProfileViewParam(
                      profileData: userData,
                    ),
                  );
                },
                child: const Icon(
                  PhosphorIcons.pencilSimpleLineBold,
                  color: MyColors.yellow01,
                  size: 20,
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildGridListMenu(
    List<HomeItemModel> data,
    bool isMainMenu,
    HomeViewModel? model,
  ) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: isMainMenu ? 18 : 0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 130,
      ),
      itemBuilder: (context, index) {
        if (data[index].title == "Permohonan" &&
            model != null &&
            model.approvalNumbers != null) {
          return Stack(
            children: [
              CustomCardWidget(
                cardType: CardType.menu,
                title: data[index].title,
                titleSize: 12,
                icon: data[index].icon,
                onTap: () {
                  Navigator.pushNamed(context, data[index].route)
                      .then((value) async {
                    if (value == null) return;
                    if (value == true) {
                      await model.getApprovalNotificationBatchNumber();
                    }
                  });
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.red,
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  child: Text(
                    model.approvalNumbers.toString(),
                    style: buildTextStyle(
                      fontSize: 14,
                      fontColor: MyColors.white,
                      fontWeight: 600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return CustomCardWidget(
          cardType: CardType.menu,
          title: data[index].title,
          titleSize: 12,
          icon: data[index].icon,
          onTap: () {
            Navigator.pushNamed(context, data[index].route);
          },
        );
      },
    );
  }
}
