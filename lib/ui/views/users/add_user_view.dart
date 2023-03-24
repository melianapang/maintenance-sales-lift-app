import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Tambah User",
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
          Navigator.pushNamed(context, Routes.setPasswordUser);
        },
        text: 'Simpan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24.0,
        ),
        child: Column(
          children: [
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Nama",
              hintText: "Nama User",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Peran",
              hintText: "Admin/Sales/Teknisi",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Alamat",
              hintText: "Alamat User",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Kota",
              hintText: "Surabaya",
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "No Telepon",
              hintText: "081xxxxxxxxxx",
              keyboardType: TextInputType.number,
            ),
            Spacings.vert(24),
            TextInput.editable(
              onChangedListener: (text) {},
              label: "Email",
              hintText: "user123@gmail.com",
              keyboardType: TextInputType.emailAddress,
            ),
            Spacings.vert(24),
          ],
        ),
      ),
    );
  }
}
