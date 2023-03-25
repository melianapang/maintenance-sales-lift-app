import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/home_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/manage_profile_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import '../../core/app_constants/colors.dart';
import '../../core/models/profile_data_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    required this.profileData,
    super.key,
  });

  final ProfileData profileData;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget _buildProfileCard(ProfileData userData) {
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
          padding: const EdgeInsets.all(
            16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
                  width: 48,
                  height: 48,
                ),
              ),
              Spacings.horz(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.username,
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.yellow01,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.phone,
                          size: 12,
                          color: MyColors.lightBlack02,
                        ),
                        Spacings.horz(6),
                        Text(
                          userData.notelp,
                          style: buildTextStyle(
                            fontSize: 14,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.envelopeSimple,
                          size: 12,
                          color: MyColors.lightBlack02,
                        ),
                        Spacings.horz(6),
                        Text(
                          userData.email,
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
                    arguments: widget.profileData,
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

  Widget _buildGridListMenu(List<HomeItemModel> data, bool isMainMenu) {
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

  @override
  Widget build(BuildContext context) {
    List<HomeItemModel> userMenus = homeMenu
        .where((element) => element.role.contains(widget.profileData.role))
        .toList();

    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.darkBlack01,
      body: Padding(
        padding: PaddingUtils.getPadding(context, defaultPadding: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(widget.profileData),
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
                homeMenu
                    .where((element) => element.role.contains(Role.Admin))
                    .toList(),
                true,
              ),
              if (widget.profileData.role == Role.Admin ||
                  widget.profileData.role == Role.SuperAdmin) ...[
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        manageProfileMenu[index].callback!(
                          context: context,
                        );
                      } else if (manageProfileMenu[index].route != null) {
                        Navigator.pushNamed(context,
                            manageProfileMenu[index].route ?? Routes.home);
                      } else {
                        null;
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
