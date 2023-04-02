import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/log/detail_log_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

import '../../shared/app_bars.dart';

class DetailLogViewParam {
  DetailLogViewParam({
    this.logData,
  });

  final LogData? logData;
}

class DetailLogView extends StatefulWidget {
  const DetailLogView({
    required this.param,
    super.key,
  });

  final DetailLogViewParam param;

  @override
  State<DetailLogView> createState() => _DetailLogViewState();
}

class _DetailLogViewState extends State<DetailLogView> {
  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailLogViewModel(
        logData: widget.param.logData,
      ),
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
                    text: model.logData?.userCreatedId,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Jenis Data yang diubah",
                    text: model.logData?.modulenName,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "ID Data",
                    text: model.logData?.changeId,
                  ),
                  Spacings.vert(24),
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
                            fontColor: MyColors.lightBlack02,
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
                            fontColor: MyColors.lightBlack02,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacings.vert(24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: model.logData?.contentsNew.length ?? 0,
                    separatorBuilder: (context, index) => const Divider(
                      color: MyColors.lightBlack01,
                      thickness: 0.4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> oldData =
                          model.logData?.contentsOld ?? {};

                      final Map<String, dynamic> newData =
                          model.logData?.contentsNew ?? {};

                      print(
                          "halooo: ${oldData.keys.toList()[index]}:${oldData.values.toList()[index]}; ${newData.keys.toList()[index]}:${newData.values.toList()[index]}");

                      return _buildBeforeAfterLogItem(
                        StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                          oldData.keys.toList()[index].toString(),
                        ),
                        StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                          oldData.values.toList()[index].toString(),
                        ),
                        StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                          newData.keys.toList()[index].toString(),
                        ),
                        StringUtils.replaceUnderscoreToSpaceAndTitleCase(
                          newData.values.toList()[index].toString(),
                        ),
                        StringUtils.isStringDifferent(
                          oldData.values.toList()[index].toString(),
                          newData.values.toList()[index].toString(),
                        ),
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
    bool isChanged,
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
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  description,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 18,
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
                    fontSize: 14,
                    fontColor:
                        isChanged ? MyColors.yellow01 : MyColors.lightBlack02,
                    fontWeight: 700,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  description2,
                  maxLines: null,
                  style: buildTextStyle(
                    fontSize: 18,
                    fontColor:
                        isChanged ? MyColors.yellow01 : MyColors.lightBlack02,
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
