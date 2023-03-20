import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

Widget buildSearchBar(BuildContext context,
    {required TextEditingController controller,
    required bool isFilterShown,
    VoidCallback? onTap}) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: TextInput(
            controller: controller,
            enabled: true,
            hintText: "Search",
            prefixIcon: const Icon(
              PhosphorIcons.magnifyingGlassBold,
            ),
            backgroundColor: MyColors.white,
          ),
        ),
        if (isFilterShown) ...[
          GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(5)),
              width: 50,
              child: const Icon(
                PhosphorIcons.slidersBold,
                color: MyColors.lightGrey,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
