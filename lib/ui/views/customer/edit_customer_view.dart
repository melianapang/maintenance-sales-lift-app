import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class EditCustomerView extends StatefulWidget {
  const EditCustomerView({super.key});

  @override
  State<EditCustomerView> createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends State<EditCustomerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGreyBackground,
      appBar: buildDefaultAppBar(
        context,
        title: "Edit Data Pelanggan",
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
        onTap: () {},
        text: 'Simpan',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            24.0,
          ),
          child: Column(
            children: [
              TextInput.editable(
                label: "Nomor Pelanggan",
                onChangedListener: (text) {},
              ),
              Spacings.vert(24),
              TextInput.editable(
                label: "Nama Pelanggan",
                onChangedListener: (text) {},
              ),
              Spacings.vert(24),
              TextInput.editable(
                label: "Nomor Telepon",
                onChangedListener: (text) {},
              ),
              Spacings.vert(24),
              TextInput.editable(
                label: "Kota",
                onChangedListener: (text) {},
              ),
              Spacings.vert(24),
              TextInput.editable(
                label: "Email",
                onChangedListener: (text) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
