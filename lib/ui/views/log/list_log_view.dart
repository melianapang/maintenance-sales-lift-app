import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListLogView extends StatefulWidget {
  const ListLogView({super.key});

  @override
  State<ListLogView> createState() => _ListLogViewState();
}

class _ListLogViewState extends State<ListLogView> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Log",
        isBackEnabled: true,
      ),
      body: Column(
        children: [
          buildSearchBar(
            context,
            controller: searchController,
            isFilterShown: false,
            onTap: () {},
          ),
          Spacings.vert(12),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: 10,
                separatorBuilder: (context, index) => const Divider(
                      color: MyColors.transparent,
                      height: 20,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomCardWidget(
                    cardType: CardType.list,
                    title: "Nadia Ang",
                    description: "Diubah oleh: Olivia North",
                    description2: "12 March 2023",
                    titleSize: 20,
                    descSize: 16,
                    desc2Size: 12,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.detailLog);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}