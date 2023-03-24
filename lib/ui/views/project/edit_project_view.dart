import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class EditProjectView extends StatefulWidget {
  const EditProjectView({super.key});

  @override
  State<EditProjectView> createState() => _EditProjectViewState();
}

class _EditProjectViewState extends State<EditProjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Edit Data Proyek",
        isBackEnabled: true,
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
          Navigator.maybePop(context);
        },
        text: 'Simpan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24.0,
        ),
        child: Column(
          children: [
            TextInput.disabled(
              label: "Nama Proyek",
              hintText: "Nama Proyek",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Nama Perusahaan",
              hintText: "Nama Perusahaan",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Lokasi",
              hintText: "Tower A",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "PIC Sales",
              hintText: "Nama PIC Sales",
              keyboardType: TextInputType.number,
            ),
            Spacings.vert(24),
          ],
        ),
      ),
    );
  }
}