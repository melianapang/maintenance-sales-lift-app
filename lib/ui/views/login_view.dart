import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/manage_account/login_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/dialogs.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<LoginViewModel>(
      model: LoginViewModel(
        dioService: Provider.of<DioService>(context),
        dioJwtService: Provider.of<DioService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: (LoginViewModel model) async {
        await model.initModel();
      },
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_pt_rejo.png',
                      width: 130,
                      height: 130,
                    ),
                    Spacings.vert(48),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Log In",
                        style: buildTextStyle(
                          fontSize: 42,
                          fontWeight: 800,
                          fontColor: MyColors.lightBlack02,
                        ),
                      ),
                    ),
                    Spacings.vert(10),
                    TextInput.editable(
                      controller: model.usernameController,
                      borderColor: MyColors.secondaryLightBlack,
                      hintText: 'Username/Email',
                      prefixIcon: Icon(
                        Icons.person,
                        color: !model.isUsernameValid
                            ? Colors.redAccent
                            : MyColors.yellow01,
                      ),
                      validator: model.usernameValidator,
                      onChangedListener: model.onChangedUsername,
                    ),
                    Spacings.vert(24),
                    TextInput.editable(
                      controller: model.passwordController,
                      onChangedListener: model.onChangedPassword,
                      maxLines: 1,
                      isPassword: !model.showPassword,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: !model.isPasswordValid
                            ? Colors.redAccent
                            : MyColors.yellow01,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          model.setShowPassword(!model.showPassword);
                        },
                        child: Icon(
                          model.showPassword
                              ? PhosphorIcons.eyeClosed
                              : PhosphorIcons.eye,
                          color: !model.isPasswordValid
                              ? Colors.redAccent
                              : MyColors.yellow01,
                        ),
                      ),
                      hintText: "Password",
                      borderColor: MyColors.secondaryLightBlack,
                    ),
                    Spacings.vert(24),
                    ButtonWidget(
                      buttonType: ButtonType.primary,
                      text: "Login",
                      textStyle: buildTextStyle(
                        fontSize: 18,
                        fontColor: MyColors.yellow01,
                        fontWeight: 500,
                      ),
                      onTap: !model.busy
                          ? () async {
                              buildLoadingDialog(context);
                              final bool result = await model.requestLogin();
                              Navigator.pop(context);

                              if (!result) {
                                showErrorDialog(
                                  context,
                                  text: model.errorMsg,
                                );
                                return;
                              }

                              Navigator.popAndPushNamed(
                                context,
                                Routes.home,
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
