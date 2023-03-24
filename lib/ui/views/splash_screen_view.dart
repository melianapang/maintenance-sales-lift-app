import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
      () => Navigator.popAndPushNamed(
        context,
        Routes.login,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBlack01,
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/logo_pt_rejo.png',
              ),
              width: 200,
              height: 200,
            ),
            Spacings.vert(18),
            Text(
              "PT REJO JAYA SAKTI",
              style: buildTextStyle(
                fontSize: 24,
                fontWeight: 800,
                fontColor: MyColors.lightBlack02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
