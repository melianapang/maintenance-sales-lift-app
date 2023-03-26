import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
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
      backgroundColor: MyColors.darkBlack01,
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
                  positiveCallback: () async {
                    await Navigator.maybePop(context);

                    showDialogWidget(
                      context,
                      title: "Menolak Permohonan",
                      isSuccessDialog: true,
                      description: "Permintaan telah ditolak.",
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
                  positiveCallback: () async {
                    await Navigator.maybePop(context);

                    showDialogWidget(
                      context,
                      title: "Menyetujui Permohonan",
                      description: "Permintaan telah disetujui.",
                      isSuccessDialog: true,
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
              const Divider(
                thickness: 0.5,
                color: MyColors.lightBlack02,
              ),
              Spacings.vert(32),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Dirawat oleh",
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 600,
                  ),
                ),
              ),
              Spacings.vert(12),
              TextInput.disabled(
                label: "Nama Teknisi:",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "No Telepon:",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
