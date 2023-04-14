import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/export_data_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/date_picker.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExportDataMaintenanceView extends StatefulWidget {
  const ExportDataMaintenanceView({super.key});

  @override
  State<ExportDataMaintenanceView> createState() =>
      _ExportDataMaintenanceViewState();
}

class _ExportDataMaintenanceViewState extends State<ExportDataMaintenanceView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ExportDataMaintenanceViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ExportDataMaintenanceViewModel model) async {
        await model.initModel();
        if (!model.isAllowedToOpenPage) Navigator.pop(context);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Export Data Pemeliharaan",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget(
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: !model.busy
                ? () async {
                    buildLoadingDialog(context);
                    await model.requestExportData();

                    Navigator.pop(context);
                    showDialogWidget(
                      context,
                      title: "Unduh Data",
                      isSuccessDialog: true,
                      description:
                          "Unduh data berhasil. \n Anda bisa melihat berkasnya di folder Download perangkat anda. Atau dengan klik tombol dibawah ini.",
                      positiveLabel: "OK",
                      negativeLabel: "Lihat Data",
                      positiveCallback: () {
                        Navigator.maybePop(context);
                      },
                      negativeCallback: () async {
                        await model.openExportedData();
                        Navigator.maybePop(context);
                      },
                    );
                  }
                : null,
            text: 'Unduh Data',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  DatePickerWidget(
                    label: "Rentang Tanggal",
                    isRangeCalendar: true,
                    selectedDates: model.selectedDates,
                    onSelectedDates: (DateTime start, DateTime? end) {
                      print('$start $end');
                      model.setSelectedDates([
                        start,
                        if (end != null) end,
                      ]);
                    },
                  ),
                  Spacings.vert(24),
                  GestureDetector(
                    onTap: () {},
                    child: TextInput.disabled(
                      label: "Status Pemeliharaan",
                      text: 'Semua',
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.darkBlue01,
                        size: 16,
                      ),
                    ),
                  ),
                  Spacings.vert(24),
                  GestureDetector(
                    onTap: () {
                      _showPilihProyekBottomDialog(
                        context,
                        model,
                        setSelectedMenu: model.setSelectedProyek,
                      );
                    },
                    child: TextInput.disabled(
                      label: "Pilih Proyek",
                      hintText: "Pilih proyek yang diinginkan",
                      text: model.selectedProject?.projectName,
                      suffixIcon: const Icon(
                        PhosphorIcons.caretDownBold,
                        color: MyColors.lightBlack02,
                      ),
                    ),
                  ),
                  Spacings.vert(24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPilihProyekBottomDialog(
    BuildContext context,
    ExportDataMaintenanceViewModel model, {
    required void Function({
      required int selectedIndex,
    })
        setSelectedMenu,
  }) {
    showGeneralBottomSheet(
      context: context,
      title: 'Daftar Pelanggan',
      isFlexible: false,
      showCloseButton: false,
      sizeToScreenRatio: 0.8,
      child: !model.isShowNoDataFoundPage && !model.busy
          ? Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () => model.requestGetAllProjects(),
                scrollDirection: Axis.vertical,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.listProject?.length ?? 0,
                  separatorBuilder: (_, __) => const Divider(
                    color: MyColors.transparent,
                    height: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCardWidget(
                      cardType: CardType.list,
                      title: model.listProject?[index].projectName ?? "",
                      description: model.listProject?[index].customerName,
                      desc2Size: 16,
                      titleSize: 20,
                      onTap: () {
                        setSelectedMenu(
                          selectedIndex: index,
                        );
                        Navigator.maybePop(context);
                      },
                    );
                  },
                ),
              ),
            )
          : buildNoDataFoundPage(),
    );
  }
}
