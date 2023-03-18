import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/login/login_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
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
  final TextEditingController unameController =
      TextEditingController(text: "admin");
  final TextEditingController pwdController =
      TextEditingController(text: "admin");
  @override
  Widget build(BuildContext context) {
    return ViewModel<LoginViewModel>(
      model: LoginViewModel(),
      onModelReady: (LoginViewModel model) async {
        await model.initModel();
      },
      builder: (_, model, __) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Log In",
                    style: buildTextStyle(
                      fontSize: 42,
                      fontWeight: 800,
                      fontColor: MyColors.darkBlue01,
                    ),
                  ),
                ),
                Spacings.vert(10),
                TextInput(
                  controller: unameController,
                  borderColor: MyColors.darkBlue01,
                  hintText: 'Username',
                  prefixIcon: Icon(
                    Icons.person,
                    color: model.isValid == false
                        ? Colors.redAccent
                        : MyColors.darkBlue01,
                  ),
                  errorText:
                      model.isValid == false ? "Your username is wrong" : null,
                ),
                Spacings.vert(24),
                TextInput(
                  controller: pwdController,
                  isPassword: !model.showPassword,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: model.isValid == false
                        ? Colors.redAccent
                        : MyColors.darkBlue01,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => model.setShowPassword(!model.showPassword),
                    child: Icon(
                      model.showPassword
                          ? PhosphorIcons.eyeClosed
                          : PhosphorIcons.eye,
                      color: model.isValid == false
                          ? Colors.redAccent
                          : MyColors.greyColor,
                    ),
                  ),
                  hintText: "Password",
                  borderColor: MyColors.darkBlue01,
                  errorText:
                      model.isValid == false ? "Your username is wrong" : null,
                ),
                Spacings.vert(24),
                ButtonWidget(
                  buttonType: ButtonType.primary,
                  text: "Login",
                  textStyle: buildTextStyle(
                    fontSize: 18,
                    fontColor: Colors.white,
                    fontWeight: 500,
                  ),
                  onTap: !model.busy
                      ? () async {
                          final bool? result = await model.requestLogin(
                            unameController.text,
                            pwdController.text,
                          );
                          if (result == false) {
                            showErrorDialog(context);
                            return;
                          }
                          Navigator.popAndPushNamed(
                            context,
                            Routes.home,
                            arguments: ProfileData(
                              username: unameController.text,
                              firstName: 'Taylor',
                              lastName: 'Swift',
                              notelp: '0812345678910',
                              email: 'admin123@gmail.com',
                              address: 'Jalan Mangga 2134',
                              city: 'Surabaya',
                              role: Role.Admin,
                            ),
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
