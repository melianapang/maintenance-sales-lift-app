import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/log/detail_log_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class DetailLogView extends StatefulWidget {
  const DetailLogView({super.key});

  @override
  State<DetailLogView> createState() => _DetailLogViewState();
}

class _DetailLogViewState extends State<DetailLogView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailLogViewModel(),
      onModelReady: (DetailLogViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Detail Log",
            isBackEnabled: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ),
              child: Column(
                children: [
                  TextInput.disabled(
                    label: "Perubahan data dilakukan oleh",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Disetujui oleh",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Jenis Data yang diubah",
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "ID Data",
                  ),
                  Spacings.vert(12),
                  const Divider(
                    thickness: 0.5,
                    color: MyColors.yellow,
                  ),
                  Spacings.vert(12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Sebelum",
                          textAlign: TextAlign.center,
                          style: buildTextStyle(
                            fontSize: 20,
                            fontColor: MyColors.yellow01,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Sesudah",
                          textAlign: TextAlign.center,
                          style: buildTextStyle(
                            fontSize: 20,
                            fontColor: MyColors.yellow01,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacings.vert(16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    separatorBuilder: (context, index) => const Divider(
                      color: MyColors.lightBlack01,
                      thickness: 0.4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildBeforeAfterLogItem(
                        "title",
                        "descriptiondescriptiondescc",
                        "titletitletitle",
                        "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondesc",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBeforeAfterLogItem(
    String title,
    String description,
    String title2,
    String description2,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  description,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 400,
                  ),
                ),
              ],
            ),
          ),
          Spacings.horz(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  textAlign: TextAlign.start,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  description2,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
