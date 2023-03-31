import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/global_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/custom_base_url_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:provider/provider.dart';

class CustomBaseURLView extends StatelessWidget {
  const CustomBaseURLView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModel<CustomBaseURLViewModel>(
      model: CustomBaseURLViewModel(
        globalConfigService: Provider.of<GlobalConfigService>(context),
      ),
      builder: (_, model, __) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInput(
                  controller: model.customBaseURLController,
                  backgroundColor: MyColors.white,
                  label: 'Custom Base URL',
                  hintText: 'URL',
                  fontColor: MyColors.black,
                ),
                Spacings.vert(24),
                ButtonWidget(
                  buttonType: ButtonType.primary,
                  text: 'Use base.env',
                  onTap: () {
                    model.customBaseURLController.text =
                        model.baseURL = EnvConstants.baseURL;
                  },
                ),
                Spacings.vert(24),
                ButtonWidget(
                  buttonType: ButtonType.primary,
                  text: 'Save',
                  onTap: () {
                    model.baseURL = model.customBaseURLController.text;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
