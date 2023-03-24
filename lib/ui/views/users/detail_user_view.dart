import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetailUserView extends StatefulWidget {
  const DetailUserView({
    required this.profileData,
    super.key,
  });

  final ProfileData profileData;

  @override
  State<DetailUserView> createState() => _DetailUserViewState();
}

class _DetailUserViewState extends State<DetailUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      appBar: buildDefaultAppBar(
        context,
        title: "Data User",
        isBackEnabled: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.editUser);
            },
            child: const Padding(
              padding: EdgeInsets.only(
                right: 20.0,
              ),
              child: Icon(
                PhosphorIcons.pencilSimpleLineBold,
                color: MyColors.lightBlack02,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.profileData.role == Role.SuperAdmin
          ? ButtonWidget.bottomSingleButton(
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
                  title: "Menghapus Data User",
                  description: "Anda yakin ingin menghapus User ini?",
                  positiveLabel: "Iya",
                  negativeLabel: "Tidak",
                  positiveCallback: () async {
                    await Navigator.maybePop(context);

                    showDialogWidget(
                      context,
                      title: "Menghapus Data User",
                      description: "User telah dihapus.",
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
              text: 'Hapus User',
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24.0,
        ),
        child: Column(
          children: [
            TextInput.disabled(
              label: "Nama User",
            ),
            Spacings.vert(24),
            TextInput.disabled(
              label: "Peran",
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
              label: "No Telepon",
            ),
            Spacings.vert(24),
            TextInput.disabled(
              label: "Email",
            ),
            Spacings.vert(24),
          ],
        ),
      ),
    );
  }
}