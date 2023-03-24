import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_constants/colors.dart';
import 'package:flutter_application_1/core/utilities/text_styles.dart';
import 'package:flutter_application_1/core/viewmodels/customer/add_customer_view_model.dart';
import 'package:flutter_application_1/core/viewmodels/customer/edit_customer_view_model.dart';
import 'package:flutter_application_1/ui/shared/spacings.dart';
import 'package:flutter_application_1/ui/widgets/buttons.dart';
import 'package:flutter_application_1/ui/widgets/dialogs.dart';

class FilterOption {
  final String title;
  bool isSelected = false;

  FilterOption(this.title, this.isSelected);
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

//build filter menu for customer
void showCustomerFilterMenu(
  BuildContext context, {
  required List<FilterOption> listPelangganMenu,
  required List<FilterOption> listSumberDataMenu,
  required List<FilterOption> listTahapKonfirmasiMenu,
  required List<FilterOption> listSortMenu,
  required int selectedPelanggan,
  required int selectedSumberData,
  required int selectedTahapKonfirmasi,
  required int selectedSort,
  required void Function({
    required int selectedPelanggan,
    required int selectedSumberData,
    required int selectedTahapKonfirmasi,
    required int selectedSort,
  })
      terapkanCallback,
}) {
  final List<FilterOption> tipePelangganLocal =
      convertToNewList(listPelangganMenu);
  int tipePelanggan = selectedPelanggan;

  final List<FilterOption> sumberDataLocal =
      convertToNewList(listSumberDataMenu);
  int sumberData = selectedSumberData;

  final List<FilterOption> tahapKonfirmasiLocal =
      convertToNewList(listTahapKonfirmasiMenu);
  int tahapKonfirmasi = selectedTahapKonfirmasi;

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
              "Tipe Pelanggan",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              tipePelangganLocal,
              (int selectedIndex) {
                tipePelanggan = selectedIndex;
                for (int i = 0; i < tipePelangganLocal.length; i++) {
                  if (i == selectedIndex) {
                    tipePelangganLocal[i].isSelected = true;
                    continue;
                  }

                  tipePelangganLocal[i].isSelected = false;
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
              "Tahap Konfirmasi",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              tahapKonfirmasiLocal,
              (int selectedIndex) {
                tahapKonfirmasi = selectedIndex;
                for (int i = 0; i < tahapKonfirmasiLocal.length; i++) {
                  if (i == selectedIndex) {
                    tahapKonfirmasiLocal[i].isSelected = true;
                    continue;
                  }

                  tahapKonfirmasiLocal[i].isSelected = false;
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
                  selectedTahapKonfirmasi: tahapKonfirmasi,
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

//build filter menu for maintenance
void showMaintenanceFilterMenu(
  BuildContext context, {
  required List<FilterOption> listHandledByMenu,
  required List<FilterOption> listSortMenu,
  required int selectedHandledBy,
  required int selectedSort,
  required void Function({
    required int selectedHandledBy,
    required int selectedSort,
  })
      terapkanCallback,
}) {
  final List<FilterOption> handledByLocal = convertToNewList(listHandledByMenu);
  int handledBy = selectedHandledBy;

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
              "Ditangani oleh",
              style: buildTextStyle(
                fontSize: 14,
                fontWeight: 400,
                fontColor: MyColors.lightBlack02,
              ),
            ),
            Spacings.vert(8),
            _buildFilterOptionsWidget(
              handledByLocal,
              (int selectedIndex) {
                handledBy = selectedIndex;
                for (int i = 0; i < handledByLocal.length; i++) {
                  if (i == selectedIndex) {
                    handledByLocal[i].isSelected = true;
                    continue;
                  }

                  handledByLocal[i].isSelected = false;
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
                  selectedHandledBy: handledBy,
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
