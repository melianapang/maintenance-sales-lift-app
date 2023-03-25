import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListUserView extends StatefulWidget {
  const ListUserView({super.key});

  @override
  State<ListUserView> createState() => _ListUserViewState();
}

class _ListUserViewState extends State<ListUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "User",
        isBackEnabled: true,
      ),
      floatingActionButton: FloatingButtonWidget(onTap: () {
        Navigator.pushNamed(context, Routes.addUser);
      }),
      body: Column(
        children: [
          buildSearchBar(
            context,
            textSearchOnChanged: (text) {},
            isFilterShown: false,
          ),
          Spacings.vert(12),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 10,
              separatorBuilder: (_, __) => const Divider(
                color: MyColors.transparent,
                height: 20,
              ),
              itemBuilder: (BuildContext context, int index) {
                return CustomCardWidget(
                  cardType: CardType.list,
                  title: "Nadia Ang",
                  titleSize: 20,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.detailUser);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
