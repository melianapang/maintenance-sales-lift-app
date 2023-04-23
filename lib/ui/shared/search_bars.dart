import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
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
