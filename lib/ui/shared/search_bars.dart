import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget buildSearchBar(
  BuildContext context, {
  bool? isEnabled,
  required bool isFilterShown,
  required TextEditingController searchController,
  required void Function(String) textSearchOnChanged,
  VoidCallback? onTapFilter,
}) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: TextInput.editable(
            onChangedListener: textSearchOnChanged,
            controller: searchController,
            hintText: "Search",
            isEnabled: isEnabled,
            prefixIcon: const Icon(
              PhosphorIcons.magnifyingGlassBold,
              color: MyColors.lightBlack02,
            ),
          ),
        ),
        if (isFilterShown) ...[
          GestureDetector(
            onTap: onTapFilter,
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              decoration: BoxDecoration(
                  color: MyColors.darkBlack02,
                  borderRadius: BorderRadius.circular(10)),
              width: 50,
              child: const Icon(
                PhosphorIcons.slidersBold,
                color: MyColors.lightBlack02,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

Widget buildSearchBarWithSortMenu(
  BuildContext context, {
  bool? isEnabled,
  bool isNowSortAscending = true,
  required TextEditingController searchController,
  required void Function(String) textSearchOnChanged,
  VoidCallback? onTapFilter,
}) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: TextInput.editable(
            onChangedListener: textSearchOnChanged,
            controller: searchController,
            hintText: "Search",
            isEnabled: isEnabled,
            prefixIcon: const Icon(
              PhosphorIcons.magnifyingGlassBold,
              color: MyColors.lightBlack02,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTapFilter,
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
                color: MyColors.darkBlack02,
                borderRadius: BorderRadius.circular(10)),
            width: 50,
            child: Icon(
              isNowSortAscending
                  ? PhosphorIcons.sortDescendingBold
                  : PhosphorIcons.sortAscendingBold,
              color: MyColors.lightBlack02,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildSearchBarAndAddableMenu(
  BuildContext context, {
  bool? isEnabled,
  required bool isShowingAddableMenu,
  required TextEditingController searchController,
  required void Function(String) textSearchOnChanged,
  VoidCallback? onTapFilter,
}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(
      20,
      0,
      20,
      20,
    ),
    child: Row(
      children: [
        Expanded(
          child: TextInput.editable(
            onChangedListener: textSearchOnChanged,
            controller: searchController,
            hintText: "Search",
            isEnabled: isEnabled,
            prefixIcon: const Icon(
              PhosphorIcons.magnifyingGlassBold,
              color: MyColors.lightBlack02,
            ),
            suffixIcon: isShowingAddableMenu
                ? GestureDetector(
                    onTap: onTapFilter,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: MyColors.yellow01,
                          borderRadius: BorderRadius.circular(10)),
                      width: 30,
                      height: 30,
                      child: const Icon(
                        PhosphorIcons.plusBold,
                        color: MyColors.darkBlack01,
                        size: 14,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        Spacings.horz(12),
      ],
    ),
  );
}
