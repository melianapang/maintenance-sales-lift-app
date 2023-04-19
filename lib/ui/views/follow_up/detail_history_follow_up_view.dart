import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/follow_up/detail_history_follow_up_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:intl/intl.dart';

class DetailHistoryFollowUpViewParam {
  DetailHistoryFollowUpViewParam({
    this.historyData,
  });

  final HistoryFollowUpData? historyData;
}

class DetailHistoryFollowUpView extends StatefulWidget {
  const DetailHistoryFollowUpView({
    required this.param,
    super.key,
  });

  final DetailHistoryFollowUpViewParam param;

  @override
  State<DetailHistoryFollowUpView> createState() =>
      _DetailHistoryFollowUpViewState();
}

class _DetailHistoryFollowUpViewState extends State<DetailHistoryFollowUpView> {
  List<GalleryData> galleryData = [
    GalleryData(
      filepath:
          "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
      galleryType: GalleryType.PHOTO,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModel(
        model: DetailHistoryFollowUpViewModel(
          historyData: widget.param.historyData,
        ),
        onModelReady: (DetailHistoryFollowUpViewModel model) async {
          await model.initModel();
        },
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: MyColors.darkBlack01,
            appBar: buildDefaultAppBar(
              context,
              title: "Detail Riwayat Konfirmasi",
              isBackEnabled: true,
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                right: 24.0,
                bottom: 24.0,
                left: 24.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacings.vert(20),
                    Text(
                      model.historyData?.customerName ?? "",
                      style: buildTextStyle(
                        fontSize: 32,
                        fontWeight: 800,
                        fontColor: MyColors.yellow01,
                      ),
                    ),
                    Text(
                      model.historyData?.companyName ?? "",
                      style: buildTextStyle(
                        fontSize: 20,
                        fontWeight: 400,
                        fontColor: MyColors.lightBlack02,
                      ),
                    ),
                    Spacings.vert(35),
                    StatusCardWidget(
                      cardType: StatusCardType.Pending,
                      onTap: () {},
                    ),
                    Spacings.vert(35),
                    TextInput.disabled(
                      label: "Tanggal Konfirmasi",
                      text: DateTimeUtils.convertStringToOtherStringDateFormat(
                        date: model.historyData?.scheduleDate ??
                            DateTimeUtils.convertDateToString(
                              date: DateTime.now(),
                              formatter: DateFormat(
                                DateTimeUtils.DATE_FORMAT_2,
                              ),
                            ),
                        formattedString: DateTimeUtils.DATE_FORMAT_2,
                      ),
                    ),
                    Spacings.vert(24),
                    TextInput.disabled(
                      label: "Catatan",
                      hintText: "Catatan Riwayat Konfirmasi",
                      text: model.historyData?.note ?? "",
                    ),
                    Spacings.vert(24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Foto",
                        style: buildTextStyle(
                          fontSize: 14,
                          fontWeight: 400,
                          fontColor: MyColors.lightBlack02,
                        ),
                      ),
                    ),
                    Spacings.vert(8),
                    GalleryThumbnailWidget(
                      isCRUD: false,
                      galleryData: galleryData,
                      galleryType: GalleryType.PHOTO,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
