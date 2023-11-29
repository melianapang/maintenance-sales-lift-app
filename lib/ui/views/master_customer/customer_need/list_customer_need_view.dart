import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/master_customer/list_customer_need_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/no_data_found_page.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/cards.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class ListCustomerNeedView extends StatefulWidget {
  const ListCustomerNeedView({super.key});

  @override
  State<ListCustomerNeedView> createState() => _ListCustomerNeedViewState();
}

class _ListCustomerNeedViewState extends State<ListCustomerNeedView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: ListCustomerNeedViewModel(
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (ListCustomerNeedViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: "Keperluan Pelanggan",
            isBackEnabled: true,
          ),
          body: !model.busy
              ? SingleChildScrollView(
                  child: Padding(
                    padding: PaddingUtils.getPadding(
                      context,
                      defaultPadding: 20,
                    ),
                    child: Column(
                      children: [
                        if (model.isAddingNewData) ...[
                          TextInput.editable(
                            label: 'Nama Keperluan',
                            hintText: 'Keperluan Pelanggan',
                            controller: model.namaKeperluanController,
                            onChangedListener: model.onChangedName,
                            errorText: !model.isNameValid
                                ? "Kolom ini wajib diisi."
                                : null,
                          ),
                          Spacings.vert(24),
                          ButtonWidget(
                            text: "Simpan",
                            buttonType: ButtonType.primary,
                            buttonSize: ButtonSize.medium,
                            onTap: () {
                              showDialogWidget(
                                context,
                                title: "Tambah Data",
                                description:
                                    "Apakah anda yakin ingin menambah data Keperluan Pelanggan?",
                                positiveLabel: "Iya",
                                negativeLabel: "Tidak",
                                positiveCallback: () async {
                                  Navigator.pop(context);

                                  buildLoadingDialog(context);
                                  bool result =
                                      await model.requestCreateCustomerNeed();
                                  Navigator.pop(context);

                                  showDialogWidget(
                                    context,
                                    title: "Tambah Data",
                                    isSuccessDialog: result,
                                    description: result
                                        ? "Anda berhasil menambahkan data"
                                        : model.errorMsg ??
                                            "Anda gagal menambahkan data",
                                    positiveLabel: "Okay",
                                    positiveCallback: () =>
                                        Navigator.maybePop(context),
                                  );
                                },
                                negativeCallback: () => Navigator.pop(context),
                              );
                            },
                          ),
                        ],
                        if (!model.isAddingNewData)
                          ButtonWidget(
                            text: "Tambah Data Baru",
                            buttonType: ButtonType.primary,
                            buttonSize: ButtonSize.medium,
                            onTap: () => model.setIsAddingNewData(),
                          ),
                        Spacings.vert(32),
                        Text(
                          "Daftar Data",
                          style: buildTextStyle(
                            fontSize: 20,
                            fontWeight: 700,
                            fontColor: MyColors.yellow01,
                          ),
                        ),
                        Spacings.vert(12),
                        if (model.isShowNoDataFoundPage)
                          ...buildNoDataFoundPart(),
                        if (model.listCustomerNeed?.isNotEmpty == true)
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: model.listCustomerNeed?.length ?? 0,
                            separatorBuilder: (context, index) => const Divider(
                              color: MyColors.transparent,
                              height: 20,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCardWidget(
                                cardType: CardType.listWithIcon,
                                title: model.listCustomerNeed?[index]
                                        .customerNeedName ??
                                    "",
                                titleSize: 14,
                                icon: PhosphorIcons.trashBold,
                                onTap: () {
                                  showDialogWidget(
                                    context,
                                    title: "Hapus Data",
                                    description:
                                        "Apakah anda yakin ingin mengapus data Keperluan Pelanggan?",
                                    positiveLabel: "Iya",
                                    negativeLabel: "Tidak",
                                    positiveCallback: () async {
                                      Navigator.pop(context);

                                      buildLoadingDialog(context);
                                      bool result = await model
                                          .requestDeleteCustomerNeed(index);
                                      Navigator.pop(context);

                                      showDialogWidget(
                                        context,
                                        title: "Hapus Data",
                                        isSuccessDialog: result,
                                        description: result
                                            ? "Anda berhasil mengapus data"
                                            : model.errorMsg ??
                                                "Anda gagal mengapus data",
                                        positiveLabel: "Okay",
                                        positiveCallback: () =>
                                            Navigator.maybePop(context),
                                      );
                                    },
                                    negativeCallback: () =>
                                        Navigator.pop(context),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    buildLoadingPage(),
                  ],
                ),
        );
      },
    );
  }
}
