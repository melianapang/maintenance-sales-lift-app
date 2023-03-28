import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
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
                      width: 150,
                      height: 150,
                    ),
                    Spacings.vert(32),
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
                      text: model.inputUser,
                      onChangedListener: (text) {
                        model.setInputUser(inputUser: text);
                      },
                      borderColor: MyColors.secondaryLightBlack,
                      hintText: 'Username/Email',
                      prefixIcon: Icon(
                        Icons.person,
                        color: model.isValid == false
                            ? Colors.redAccent
                            : MyColors.yellow01,
                      ),
                      errorText: model.isValid == false
                          ? "Username / email anda salah"
                          : null,
                    ),
                    Spacings.vert(24),
                    TextInput.editable(
                      text: model.password,
                      onChangedListener: (text) {
                        model.setPassword(password: text);
                      },
                      maxLines: 1,
                      isPassword: !model.showPassword,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: model.isValid == false
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
                          color: model.isValid == false
                              ? Colors.redAccent
                              : MyColors.yellow01,
                        ),
                      ),
                      hintText: "Password",
                      borderColor: MyColors.secondaryLightBlack,
                      errorText: model.isValid == false
                          ? "Kata sandi anda salah"
                          : null,
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
                                showErrorDialog(context);
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
