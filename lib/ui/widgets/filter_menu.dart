import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';

class FilterOption {
  final String title;
  bool isSelected = false;

  FilterOption(
    this.title,
    this.isSelected,
  );
}

class FilterOptionDynamic {
  final String idFilter;
  final String title;
  bool isSelected = false;

  FilterOptionDynamic(
    this.idFilter,
    this.title,
    this.isSelected,
  );
}

Widget _buildFilterOptionsWidget(
    List<FilterOption> listMenu, void Function(int) callback) {
  return Wrap(
    spacing: 8.0,
    runSpacing: 12.0,
    children: [
      for (int i = 0; i < listMenu.length; i++)
        buildFilterOption(
          listMenu[i],
          () {
            callback(i);
          },
        ),
    ],
  );
}

Widget buildFilterOption(FilterOption menu, void Function() callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.6,
          color: !menu.isSelected ? MyColors.transparent : MyColors.yellow01,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: !menu.isSelected
            ? MyColors.lightBlack01
            : MyColors.darkGreyBackground,
      ),
      child: Text(
        menu.title,
        style: buildTextStyle(
          fontSize: 13,
          fontWeight: 600,
          fontColor: !menu.isSelected ? MyColors.white : MyColors.yellow01,
        ),
      ),
    ),
  );
}

Widget _buildFilterDynamicOptionsWidget(
    List<FilterOptionDynamic> listMenu, void Function(int) callback) {
  return Wrap(
    spacing: 8.0,
    runSpacing: 12.0,
    children: [
      for (FilterOptionDynamic menu in listMenu)
        buildFilterDynamicOption(
          menu,
          () {
            callback(
              int.parse(
                menu.idFilter,
              ),
            );
          },
        ),
    ],
  );
}

Widget buildFilterDynamicOption(
    FilterOptionDynamic menu, void Function() callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.6,
          color: !menu.isSelected ? MyColors.transparent : MyColors.yellow01,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: !menu.isSelected
            ? MyColors.lightBlack01
            : MyColors.darkGreyBackground,
      ),
      child: Text(
        menu.title,
        style: buildTextStyle(
          fontSize: 13,
          fontWeight: 600,
          fontColor: !menu.isSelected ? MyColors.white : MyColors.yellow01,
        ),
      ),
    ),
  );
}

//build filter menu for customer
void showCustomerFilterMenu(
  BuildContext context, {
  required List<FilterOptionDynamic> listPelangganMenu,
  required List<FilterOption> listSumberDataMenu,
  required List<FilterOptionDynamic> listKebutuhanPelanggan,
  required List<FilterOption> listSortMenu,
  required int? selectedPelanggan,
  required int? selectedSumberData,
  required int? selectedKebutuhanPelanggan,
  required int? selectedSort,
  required void Function({
    required int? selectedPelanggan,
    required int? selectedSumberData,
    required int? selectedKebutuhanPelanggan,
    required int? selectedSort,
  })
      terapkanCallback,
  required void Function() resetFilterCallback,
}) {
  final List<FilterOptionDynamic> tipePelangganLocal =
      convertToNewListForFilterDynamic(listPelangganMenu);
  int? tipePelanggan = selectedPelanggan;

  final List<FilterOption> sumberDataLocal =
      convertToNewList(listSumberDataMenu);
  int? sumberData = selectedSumberData;

  final List<FilterOptionDynamic> kebutuhanPelangganLocal =
      convertToNewListForFilterDynamic(listKebutuhanPelanggan);
  int? kebutuhanPelanggan = selectedKebutuhanPelanggan;

  final List<FilterOption> sortLocal = convertToNewList(listSortMenu);
  int? sort = selectedSort;

  showGeneralBottomSheet(
    context: context,
    title: 'Filters',
    isFlexible: true,
    showCloseButton: false,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tipe Pelanggan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterDynamicOptionsWidget(
              tipePelangganLocal,
              (int selectedIdFilter) {
                tipePelanggan = selectedIdFilter;
                for (FilterOptionDynamic menu in tipePelangganLocal) {
                  if (int.parse(menu.idFilter) == selectedIdFilter) {
                    menu.isSelected = true;
                    continue;
                  }

                  menu.isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(20),
            Text(
              "Sumber Data",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              sumberDataLocal,
              (int selectedIndex) {
                sumberData = selectedIndex;
                for (int i = 0; i < sumberDataLocal.length; i++) {
                  if (i == selectedIndex) {
                    sumberDataLocal[i].isSelected = true;
                    continue;
                  }

                  sumberDataLocal[i].isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(20),
            Text(
              "Kebutuhan Pelanggan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterDynamicOptionsWidget(
              kebutuhanPelangganLocal,
              (int selectedIdFilter) {
                kebutuhanPelanggan = selectedIdFilter;
                for (FilterOptionDynamic menu in kebutuhanPelangganLocal) {
                  if (int.parse(menu.idFilter) == selectedIdFilter) {
                    menu.isSelected = true;
                    continue;
                  }

                  menu.isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(20),
            Text(
              "Urutkan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              sortLocal,
              (int selectedIndex) {
                sort = selectedIndex;
                for (int i = 0; i < sortLocal.length; i++) {
                  if (i == selectedIndex) {
                    sortLocal[i].isSelected = true;
                    continue;
                  }

                  sortLocal[i].isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(24),
            ButtonWidget(
              buttonType: ButtonType.primary,
              buttonSize: ButtonSize.large,
              text: "Terapkan",
              onTap: () {
                terapkanCallback(
                  selectedPelanggan: tipePelanggan,
                  selectedSumberData: sumberData,
                  selectedKebutuhanPelanggan: kebutuhanPelanggan,
                  selectedSort: sort,
                );
                Navigator.maybePop(context);
              },
            ),
            Spacings.vert(10),
            ButtonWidget(
              buttonType: ButtonType.secondary,
              buttonSize: ButtonSize.large,
              text: "Reset Filter",
              onTap: () {
                resetFilterCallback();
                Navigator.maybePop(context);
              },
            )
          ],
        );
      },
    ),
  );
}

//build filter menu for maintenance
void showMaintenanceFilterMenu(
  BuildContext context, {
  required List<FilterOption> listMaintenanceStatusMenu,
  required List<FilterOption> listSortMenu,
  required int selectedMaintenanceStatus,
  required int selectedSort,
  required void Function({
    required int selectedMaintenanceStatus,
    required int selectedSort,
  })
      terapkanCallback,
}) {
  final List<FilterOption> maintenanceStatusLocal =
      convertToNewList(listMaintenanceStatusMenu);
  int maintenanceStatus = selectedMaintenanceStatus;

  final List<FilterOption> sortLocal = convertToNewList(listSortMenu);
  int sort = selectedSort;

  showGeneralBottomSheet(
    context: context,
    title: 'Filters',
    isFlexible: true,
    showCloseButton: false,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status Pemeliharaan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              maintenanceStatusLocal,
              (int selectedIndex) {
                maintenanceStatus = selectedIndex;
                for (int i = 0; i < maintenanceStatusLocal.length; i++) {
                  if (i == selectedIndex) {
                    maintenanceStatusLocal[i].isSelected = true;
                    continue;
                  }

                  maintenanceStatusLocal[i].isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(24),
            Text(
              "Urutkan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              sortLocal,
              (int selectedIndex) {
                sort = selectedIndex;
                for (int i = 0; i < sortLocal.length; i++) {
                  if (i == selectedIndex) {
                    sortLocal[i].isSelected = true;
                    continue;
                  }

                  sortLocal[i].isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(24),
            ButtonWidget(
              buttonType: ButtonType.primary,
              buttonSize: ButtonSize.large,
              text: "Terapkan",
              onTap: () {
                terapkanCallback(
                  selectedMaintenanceStatus: maintenanceStatus,
                  selectedSort: sort,
                );
                Navigator.maybePop(context);
              },
            )
          ],
        );
      },
    ),
  );
}

//build filter menu for user
void showUserFilterMenu(
  BuildContext context, {
  required List<FilterOption> listRole,
  required int selectedRole,
  required void Function({
    required int selectedRole,
  })
      terapkanCallback,
}) {
  final List<FilterOption> roleLocal = convertToNewList(listRole);
  int role = selectedRole;

  showGeneralBottomSheet(
    context: context,
    title: 'Filters',
    isFlexible: true,
    showCloseButton: false,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Peran",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              roleLocal,
              (int selectedIndex) {
                role = selectedIndex;
                for (int i = 0; i < roleLocal.length; i++) {
                  if (i == selectedIndex) {
                    roleLocal[i].isSelected = true;
                    continue;
                  }

                  roleLocal[i].isSelected = false;
                }
                setState(() {});
              },
            ),
            Spacings.vert(24),
            ButtonWidget(
              buttonType: ButtonType.primary,
              buttonSize: ButtonSize.large,
              text: "Terapkan",
              onTap: () async {
                terapkanCallback(
                  selectedRole: role,
                );
                Navigator.maybePop(context);
              },
            )
          ],
        );
      },
    ),
  );
}

//build choices for form.
Widget buildMenuChoices(
    List<FilterOption> listMenu, void Function(int) callback) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Wrap(
      spacing: 8.0,
      runSpacing: 12.0,
      children: [
        for (int i = 0; i < listMenu.length; i++)
          buildFilterOption(listMenu[i], () => callback(i)),
      ],
    ),
  );
}

Widget buildMenuDynamicChoices(
    List<FilterOptionDynamic> listMenu, void Function(int) callback) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Wrap(
      spacing: 8.0,
      runSpacing: 12.0,
      children: [
        for (FilterOptionDynamic menu in listMenu)
          buildFilterDynamicOption(
            menu,
            () => callback(
              int.parse(
                menu.idFilter,
              ),
            ),
          ),
      ],
    ),
  );
}

//just to convert the list to map to list again
//basically just make the copy.
List<FilterOption> convertToNewList(List<FilterOption> data) {
  return data
      .map(
        (e) => FilterOption(
          e.title,
          e.isSelected,
        ),
      )
      .toList();
}

List<FilterOptionDynamic> convertToNewListForFilterDynamic(
    List<FilterOptionDynamic> data) {
  return data
      .map(
        (e) => FilterOptionDynamic(
          e.idFilter,
          e.title,
          e.isSelected,
        ),
      )
      .toList();
}
