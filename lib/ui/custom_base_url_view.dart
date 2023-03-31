import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_constants/colors.dart';
import 'package:flutter_application_1/core/app_constants/env.dart';
import 'package:flutter_application_1/core/app_constants/routes.dart';
import 'package:flutter_application_1/core/services/global_config_service.dart';
import 'package:flutter_application_1/core/viewmodels/custom_base_url_view_model.dart';
import 'package:flutter_application_1/core/viewmodels/view_model.dart';
import 'package:flutter_application_1/ui/shared/spacings.dart';
import 'package:flutter_application_1/ui/widgets/buttons.dart';
import 'package:flutter_application_1/ui/widgets/text_inputs.dart';
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
