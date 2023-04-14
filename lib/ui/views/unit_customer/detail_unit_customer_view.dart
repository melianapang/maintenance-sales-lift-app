import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/detail_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/edit_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailUnitCustomerViewParam {
  DetailUnitCustomerViewParam({
    this.unitData,
  });

  final UnitData? unitData;
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
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editUnit,
                    arguments: EditUnitCustomerViewParam(
                      unitData: model.unitData,
                    ),
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

                  showDialogWidget(
                    context,
                    title: "Menghapus Data Unit",
                    description: "Unit telah dihapus.",
                    positiveLabel: "OK",
                    positiveCallback: () {
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
            child: SingleChildScrollView(
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
                  TextInput.disabled(
                    label: "Proyek",
                    text: model.unitData?.projectName,
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
}
