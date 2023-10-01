import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/customer/detail_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/floating_button.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/edit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/add_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailCustomerViewParam {
  DetailCustomerViewParam({
    this.customerData,
  });

  final CustomerData? customerData;
}

class DetailCustomerView extends StatefulWidget {
  const DetailCustomerView({
    required this.param,
    super.key,
  });

  final DetailCustomerViewParam param;

  @override
  State<DetailCustomerView> createState() => _DetailCustomerViewState();
}

class _DetailCustomerViewState extends State<DetailCustomerView> {
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailCustomerViewModel(
        dioService: Provider.of<DioService>(context),
        customerData: widget.param.customerData,
      ),
      onModelReady: (DetailCustomerViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Data Pelanggan",
            isBackEnabled: true,
            isPreviousPageNeedRefresh: model.isPreviousPageNeedRefresh,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editCustomer,
                    arguments: EditCustomerViewParam(
                      customerData: model.customerData,
                    ),
                  ).then(
                    (value) async {
                      if (value == null) return;
                      if (value == true) {
                        await model.refreshPage();
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
          floatingActionButton: _buildExtendedFAB(model),
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
                        Text(
                          StringUtils.removeZeroWidthSpaces(
                            model.customerData?.customerName ?? "",
                          ),
                          style: buildTextStyle(
                            fontSize: 32,
                            fontWeight: 800,
                            fontColor: MyColors.yellow01,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          model.customerData?.companyName ?? "",
                          style: buildTextStyle(
                            fontSize: 20,
                            fontWeight: 400,
                            fontColor: MyColors.lightBlack02,
                          ),
                        ),
                        Spacings.vert(35),
                        if (model.isShowingSumberData) ...[
                          TextInput.disabled(
                            label: "Sumber Data",
                            hintText: 'Sumber Data',
                            text: model.customerData?.dataSource ?? "",
                          ),
                          Spacings.vert(24),
                        ],
                        TextInput.disabled(
                          label: "Nomor Pelanggan",
                          hintText: "Nomor Pelanggan",
                          text: model.customerData?.customerNumber,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Tipe Pelanggan",
                          hintText: "Tipe Pelanggan",
                          text: model.selectedCustomerTypeFilterName,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Kebutuhan Pelanggan",
                          hintText: "Kebutuhan Pelanggan",
                          text: model.selectedCustomerNeedFilterName,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Kota",
                          hintText: "Kota",
                          text: model.customerData?.city,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "No Telepon",
                          text: model.customerData?.phoneNumber,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Email",
                          text: model.customerData?.email,
                        ),
                        Spacings.vert(24),
                        TextInput.disabled(
                          label: "Catatan",
                          hintText: "Catatan mengenai pelanggan...",
                          text: model.customerData?.note,
                        ),
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

  Widget _buildExtendedFAB(DetailCustomerViewModel model) {
    return SpeedDial(
      icon: PhosphorIcons.plusBold,
      activeIcon: PhosphorIcons.xBold,
      spacing: 3,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      dialRoot: (ctx, open, toggleChildren) {
        return FloatingButtonWidget(
          onTap: toggleChildren,
          icon: PhosphorIcons.squaresFourBold,
        );
      },
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(52.0, 52.0),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      renderOverlay: false,
      useRotationAnimation: true,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      children: [
        SpeedDialChild(
          child: !model.isDialChildrenVisible
              ? const Icon(PhosphorIcons.archiveBold)
              : null,
          backgroundColor: MyColors.yellow02,
          foregroundColor: MyColors.white,
          label: 'Daftar Unit',
          labelBackgroundColor: MyColors.lightBlack01,
          labelShadow: [
            const BoxShadow(
              color: MyColors.transparent,
            ),
          ],
          labelStyle: buildTextStyle(
              fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
          onTap: () async {
            Navigator.pushNamed(
              context,
              Routes.listUnit,
              arguments: ListUnitCustomerViewParam(
                customerType: CustomerType.ProjectCustomer,
                customerData: model.customerData,
              ),
            );

            setState() {
              model.setDialChildrenVisible();
            }
          },
        ),
        SpeedDialChild(
          child: !model.isDialChildrenVisible
              ? const Icon(PhosphorIcons.listBulletsBold)
              : null,
          backgroundColor: MyColors.yellow02,
          foregroundColor: MyColors.white,
          label: 'Riwayat Konfirmasi',
          labelBackgroundColor: MyColors.lightBlack01,
          labelShadow: [
            const BoxShadow(
              color: MyColors.transparent,
            ),
          ],
          labelStyle: buildTextStyle(
              fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.detailFollowUp,
              arguments: DetailFollowUpViewParam(
                customerId: model.customerData?.customerId,
                companyName: model.customerData?.companyName,
                customerName: model.customerData?.customerName,
              ),
            );

            setState() {
              model.setDialChildrenVisible();
            }
          },
        ),
        // SpeedDialChild(
        //   child: !model.isDialChildrenVisible
        //       ? const Icon(PhosphorIcons.uploadSimpleBold)
        //       : null,
        //   backgroundColor: MyColors.yellow02,
        //   foregroundColor: MyColors.white,
        //   label: 'Unggah Dokumen',
        //   labelBackgroundColor: MyColors.lightBlack01,
        //   labelShadow: [
        //     const BoxShadow(
        //       color: MyColors.transparent,
        //     ),
        //   ],
        //   labelStyle: buildTextStyle(
        //       fontSize: 14, fontWeight: 500, fontColor: MyColors.white),
        //   onTap: () {
        //     Navigator.pushNamed(
        //       context,
        //       Routes.uploadPO,
        //       arguments: UploadDocumentViewParam(
        //         projectId: model.customerData?.customerId,
        //       ),
        //     ).then((value) {
        //       if (value == null) return;
        //       if (value == true) {
        //         model.requestGetDetailCustomer();
        //         model.setPreviousPageNeedRefresh(true);
        //         _handleErrorDialog(context, model);
        //       }
        //     });

        //     setState() {
        //       model.setDialChildrenVisible();
        //     }
        //   },
        // ),
      ],
    );
  }

  void _handleErrorDialog(
    BuildContext context,
    DetailCustomerViewModel model,
  ) {
    if (model.errorMsg == null) return;

    showDialogWidget(context,
        title: "Daftar Data Pelanggan",
        isSuccessDialog: false,
        description: model.errorMsg ??
            "Gagal mendapatkan Data Pelanggan. \n Coba beberappa saat lagi.",
        positiveLabel: "Coba Lagi",
        negativeLabel: "Ok", positiveCallback: () async {
      model.requestGetDetailCustomer();
      Navigator.pop(context);
    }, negativeCallback: () {
      model.resetErrorMsg();
      Navigator.pop(context);
    });
  }
}
