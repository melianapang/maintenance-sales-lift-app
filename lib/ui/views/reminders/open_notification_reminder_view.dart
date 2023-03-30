import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class OpenNotificationReminderViewParam {
  OpenNotificationReminderViewParam({
    this.date = "",
    this.time = "",
    this.description = "",
    this.note = "",
  });

  final String date;
  final String time;
  final String description;
  final String note;
}

class OpenNotificationReminderView extends StatelessWidget {
  const OpenNotificationReminderView({
    required OpenNotificationReminderViewParam? this.param,
    super.key,
  });

  final OpenNotificationReminderViewParam? param;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.home, (route) => false);
        }
        return true;
      },
      child: Scaffold(
        appBar: buildDefaultAppBar(
          context,
          title: "Pengingat",
          isBackEnabled: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(
            24.0,
          ),
          child: Column(
            children: [
              TextInput.disabled(
                label: "Tanggal Pengingat",
                hintText: "Tanggal Pengingat",
                text: param?.date,
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Waktu Pengingat",
                hintText: "Waktu Pengingat",
                text: param?.time,
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Deskripsi Pengingat",
                hintText: "Tidak ada Deskripsi Pengingat",
                text: param?.description,
              ),
              Spacings.vert(24),
              TextInput.disabled(
                label: "Catatan",
                hintText: "Tidak ada Catatan Pengingat",
                text: param?.note,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
