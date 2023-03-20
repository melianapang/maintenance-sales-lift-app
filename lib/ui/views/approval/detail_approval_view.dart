import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailApprovalView extends StatefulWidget {
  const DetailApprovalView({super.key});

  @override
  State<DetailApprovalView> createState() => _DetailApprovalViewState();
}

class _DetailApprovalViewState extends State<DetailApprovalView> {
  final String nama = "Bambang Pamungkas";
  final String notelp = "0812345678910";
  final TextEditingController tipeCustomerController =
      TextEditingController(text: "Perorangan");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Detail Permohonan",
        isBackEnabled: true,
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ButtonWidget(
              padding: const EdgeInsets.only(
                right: 4.0,
                left: 24.0,
                top: 8.0,
                bottom: 8.0,
              ),
              buttonType: ButtonType.secondary,
              text: 'TOLAK',
              onTap: () {
                showDialogWidget(
                  context,
                  title: "Menolak Permohonan",
                  description:
                      "Apakahh anda yakin ingin menolak permintaan ini?",
                  positiveLabel: "Iya",
                  negativeLabel: "Tidak",
                  positiveCallback: () {},
                  negativeCallback: () {},
                );
              },
            ),
          ),
          Expanded(
            child: ButtonWidget(
              padding: const EdgeInsets.only(
                right: 24.0,
                left: 4.0,
                top: 8.0,
                bottom: 8.0,
              ),
              buttonType: ButtonType.primary,
              text: 'SETUJU',
              onTap: () {
                showDialogWidget(
                  context,
                  title: "Menyetujui Permohonan",
                  description:
                      "Apakahh anda yakin ingin menyetujui permintaan ini?",
                  positiveLabel: "Iya",
                  negativeLabel: "Tidak",
                  positiveCallback: () {},
                  negativeCallback: () {},
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            24.0,
          ),
          child: Column(
            children: [
              TextInput.disabled(
                text: 'Perorangan',
                label: "Tipe Pelanggan",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Nomor Pelanggan",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Nama Pelanggan",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Nomor Telepon",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Alamat",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Kota",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Email",
              ),
              Spacings.vert(32),
              Card(
                elevation: 2,
                shadowColor: MyColors.greyColor,
                color: MyColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    19.0,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 14.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Diminta oleh:",
                            style: buildTextStyle(
                              fontColor: MyColors.darkBlue01,
                              fontSize: 16,
                              fontWeight: 800,
                            ),
                          ),
                          Spacings.vert(8),
                          Row(
                            children: [
                              Text(
                                "Nama          :",
                                style: buildTextStyle(
                                  fontColor: MyColors.darkBlue01,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ),
                              Spacings.horz(6),
                              Text(
                                nama,
                                style: buildTextStyle(
                                  fontColor: MyColors.darkBlue01,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ),
                            ],
                          ),
                          Spacings.vert(4),
                          Row(
                            children: [
                              Text(
                                "No Telepon :",
                                style: buildTextStyle(
                                  fontColor: MyColors.darkBlue01,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ),
                              Spacings.horz(6),
                              Text(
                                notelp,
                                style: buildTextStyle(
                                  fontColor: MyColors.darkBlue01,
                                  fontSize: 16,
                                  fontWeight: 400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
