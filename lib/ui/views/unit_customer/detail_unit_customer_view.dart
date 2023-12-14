import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/detail_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/edit_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailUnitCustomerViewParam {
  DetailUnitCustomerViewParam({
    this.customerData,
    this.unitData,
    this.sourcePageForList,
  });

  final CustomerData? customerData;
  final UnitData? unitData;
  final ListUnitCustomerSourcePage? sourcePageForList;
  //when the sourcepage of list page is detail project, then disable the edit and delete button
}

class DetailUnitCustomerView extends StatefulWidget {
  const DetailUnitCustomerView({
    required this.param,
    super.key,
  });

  final DetailUnitCustomerViewParam param;

  @override
  State<DetailUnitCustomerView> createState() => _DetailUnitCustomerViewState();
}

class _DetailUnitCustomerViewState extends State<DetailUnitCustomerView> {
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailUnitCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        unitData: widget.param.unitData,
      ),
      onModelReady: (DetailUnitCustomerViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Data Unit",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editUnit,
                    arguments: EditUnitCustomerViewParam(
                      unitData: model.unitData,
                      customerData: widget.param.customerData,
                    ),
                  ).then(
                    (value) {
                      if (value == null) return;
                      if (value == true) {
                        model.refreshPage();
                        model.setPreviousPageNeedRefresh(true);
                        _handleErrorDialog(context, model);
                      }
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: Icon(
                    PhosphorIcons.pencilSimpleLineBold,
                    color: MyColors.lightBlack02,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
            buttonType: ButtonType.primary,
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            onTap: () {
              showDialogWidget(
                context,
                title: "Menghapus Data Unit",
                description: "Anda yakin ingin menghapus Unit ini?",
                positiveLabel: "Iya",
                negativeLabel: "Tidak",
                positiveCallback: () async {
                  await Navigator.maybePop(context);

                  buildLoadingDialog(context);
                  bool result = await model.requestDeleteUnit();
                  Navigator.pop(context);

                  showDialogWidget(
                    context,
                    title: "Menghapus Data Unit",
                    description: result
                        ? "Unit telah berhasil dihapus."
                        : model.errorMsg ??
                            "Unit gagal dihapus. Coba beberapa saat lagi.",
                    isSuccessDialog: result,
                    positiveLabel: "OK",
                    positiveCallback: () {
                      if (result) {
                        Navigator.of(context)
                          ..pop()
                          ..pop(true);
                        return;
                      }

                      model.resetErrorMsg();
                      Navigator.maybePop(context);
                    },
                  );
                },
                negativeCallback: () {
                  Navigator.maybePop(context);
                },
              );
            },
            text: 'Hapus Unit',
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 24.0,
              bottom: 24.0,
              left: 24.0,
            ),
            child: !model.busy
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Spacings.vert(40),
                        TextInput.disabled(
                          label: "Nama Unit",
                          text: model.unitData?.unitName,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Lokasi Unit",
                          text: model.unitData?.unitLocation,
                        ),
                        Spacings.vert(24),
                        if (model.unitData?.projectName != null) ...[
                          TextInput.disabled(
                            label: "Proyek",
                            text: model.unitData?.projectName,
                          ),
                          Spacings.vert(24),
                        ],
                        TextInput.disabled(
                          label: "Tipe Unit",
                          text: model.tipeUnit,
                          hintText: "Tipe Unit",
                        ),
                        Spacings.vert(24),
                        if (model.jenisUnit != null) ...[
                          TextInput.disabled(
                            label: "Jenis Unit",
                            text: model.jenisUnit,
                            hintText: "Jenis Unit",
                          ),
                          Spacings.vert(24),
                        ],
                        TextInput.disabled(
                          label: "Kapasitas / Rise",
                          text: model.unitData?.kapasitas.toString(),
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Speed / Inclinasi",
                          text: model.unitData?.speed.toString(),
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Jumlah Lantai / Lebar Step",
                          text: model.unitData?.totalLantai.toString(),
                        ),
                        Spacings.vert(24),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      buildLoadingPage(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    DetailUnitCustomerViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(
      context,
      title: "Daftar Riwayat Konfirmasi",
      isSuccessDialog: false,
      description: model.errorMsg ??
          "Gagal mendapatkan daftar Riwayat. \n Coba beberappa saat lagi.",
      positiveLabel: "Coba Lagi",
      positiveCallback: () async {
        Navigator.pop(context);

        buildLoadingDialog(context);
        await model.refreshPage();
        Navigator.pop(context);

        if (model.errorMsg != null) _handleErrorDialog(context, model);
      },
      negativeLabel: "Okay",
      negativeCallback: () => Navigator.pop(context),
    );
  }
}
