import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/search_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/form_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';

class ListRemindersView extends StatefulWidget {
  const ListRemindersView({super.key});

  @override
  State<ListRemindersView> createState() => _ListRemindersViewState();
}

class _ListRemindersViewState extends State<ListRemindersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Pengingat",
        isBackEnabled: true,
      ),
      floatingActionButton: FloatingButtonWidget(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.formSetReminder,
            arguments: FormSetReminderSource.ListReminderPage,
          );
        },
      ),
      body: Column(
        children: [
          buildSearchBar(
            context,
            textSearchOnChanged: (text) {},
            isFilterShown: false,
            onTapFilter: () {},
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
                    description: "PT ABC JAYA",
                    description2: "12 March 2023",
                    titleSize: 20,
                    descSize: 16,
                    desc2Size: 12,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.detailReminder);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
