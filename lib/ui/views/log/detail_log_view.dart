import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class DetailLogView extends StatefulWidget {
  const DetailLogView({super.key});

  @override
  State<DetailLogView> createState() => _DetailLogViewState();
}

class _DetailLogViewState extends State<DetailLogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGreyBackground,
      appBar: buildDefaultAppBar(
        context,
        title: "Detail Log",
        isBackEnabled: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            24.0,
          ),
          child: Column(
            children: [
              TextInput.disabled(
                label: "Perubahan data dilakukan oleh",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Disetujui oleh",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Permintaan ubah pada tanggal",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Disetujui pada tanggal",
              ),
              Spacings.vert(32),
              const Divider(
                thickness: 2,
                color: MyColors.darkBlue01,
              ),
              Spacings.vert(10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Data yang diubah",
                  style: buildTextStyle(
                    fontSize: 20,
                    fontColor: MyColors.darkBlue01,
                    fontWeight: 800,
                  ),
                ),
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
                label: "Kota",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "No Telepon",
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
