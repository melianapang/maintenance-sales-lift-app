import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_result.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/detail_history_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/map/map_view_v2.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';
import 'package:intl/intl.dart';

class DetailHistoryMaintenanceViewParam {
  DetailHistoryMaintenanceViewParam({
    this.historyData,
  });

  final HistoryMaintenanceData? historyData;
}

class DetailHistoryMaintenanceView extends StatefulWidget {
  const DetailHistoryMaintenanceView({
    required this.param,
    super.key,
  });

  final DetailHistoryMaintenanceViewParam param;

  @override
  State<DetailHistoryMaintenanceView> createState() =>
      _DetailHistoryMaintenanceViewState();
}

class _DetailHistoryMaintenanceViewState
    extends State<DetailHistoryMaintenanceView> {
  final ScrollController scrollController = ScrollController();

  List<GalleryData> galleryData = [
    GalleryData(
      filepath:
          "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://www.rollingstone.com/wp-content/uploads/2019/12/TaylorSwiftTimIngham.jpg?w=1581&h=1054&crop=1",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png/220px-191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://i.guim.co.uk/img/media/a48e88b98455a5b118d3c1d34870a1d3aaa1b5c6/0_41_3322_1994/master/3322.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=b95f25e4e31f132166006345fd87b5ae",
      galleryType: GalleryType.PHOTO,
    ),
    GalleryData(
      filepath:
          "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
      galleryType: GalleryType.PHOTO,
    ),
  ];

  List<GalleryData> videoData = [
    GalleryData(
      filepath:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailPath:
          "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
      galleryType: GalleryType.VIDEO,
    ),
    GalleryData(
      filepath:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailPath:
          "https://media.glamour.com/photos/618e9260d0013b8dece7e9d8/master/w_2560%2Cc_limit/GettyImages-1236509084.jpg",
      galleryType: GalleryType.VIDEO,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: DetailHistoryMaintenanceViewModel(
        historyMaintenanceData: widget.param.historyData,
        dioService: Provider.of<DioService>(context),
      ),
      onModelReady: (DetailHistoryMaintenanceViewModel model) async {
        await model.initModel();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          appBar: buildDefaultAppBar(
            context,
            title: "Riwayat Pemeliharaan",
            isBackEnabled: true,
          ),
          bottomNavigationBar: ButtonWidget.bottomSingleButton(
            padding: EdgeInsets.only(
              bottom: PaddingUtils.getBottomPadding(
                context,
                defaultPadding: 12,
              ),
              left: 24.0,
              right: 24.0,
            ),
            buttonType: ButtonType.primary,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.map,
                arguments: MapViewParamV2(
                  longitude: double.parse(
                    model.historyMaintenanceData?.longitude ?? "0",
                  ),
                  latitude: double.parse(
                    model.historyMaintenanceData?.latitude ?? "0",
                  ),
                  titleNote: model.historyMaintenanceData?.userName,
                  dateTime: DateTimeUtils.convertStringToOtherStringDateFormat(
                    date: model.historyMaintenanceData
                            ?.updateMaintenanceDateTime ??
                        DateTimeUtils.convertDateToString(
                          date: DateTime.now(),
                          formatter: DateFormat(
                            DateTimeUtils.DATE_FORMAT_5,
                          ),
                        ),
                    formattedString: DateTimeUtils.DATE_FORMAT_5,
                  ),
                  descNote: model.historyMaintenanceData?.note,
                ),
              );
            },
            text: 'Lihat Lokasi di Peta',
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
                    model.historyMaintenanceData?.unitName ?? "",
                    style: buildTextStyle(
                      fontSize: 32,
                      fontWeight: 800,
                      fontColor: MyColors.yellow01,
                    ),
                  ),
                  Text(
                    model.historyMaintenanceData?.customerName ?? "",
                    style: buildTextStyle(
                      fontSize: 20,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                  Spacings.vert(35),
                  StatusCardWidget(
                    cardType: model.statusCardType,
                    onTap: () {},
                  ),
                  Spacings.vert(35),
                  TextInput.disabled(
                    label: "Tanggal",
                    text: DateTimeUtils.convertStringToOtherStringDateFormat(
                      date: model.historyMaintenanceData?.scheduleDate ??
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
                    label: "Hasil Pemeliharaan",
                    text: mappingStringNumerictoString(
                      model.historyMaintenanceData?.maintenanceResult ?? "0",
                    ),
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Catatan",
                    hintText: "Tidak ada catatan...",
                    text: model.historyMaintenanceData?.note,
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
                  if (model.galleryPhotoData.isNotEmpty)
                    GalleryThumbnailWidget(
                      isCRUD: false,
                      galleryData: model.galleryPhotoData,
                      galleryType: GalleryType.PHOTO,
                    ),
                  if (model.galleryPhotoData.isEmpty)
                    Text(
                      "Tidak ada foto untuk riwayat pemeliharaan ini.",
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.lightBlack01,
                        fontWeight: 500,
                      ),
                    ),
                  Spacings.vert(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Video",
                      style: buildTextStyle(
                        fontSize: 14,
                        fontWeight: 400,
                        fontColor: MyColors.lightBlack02,
                      ),
                    ),
                  ),
                  Spacings.vert(8),
                  if (model.galleryVideoData.isNotEmpty)
                    GalleryThumbnailWidget(
                      isCRUD: false,
                      galleryData: model.galleryVideoData,
                      galleryType: GalleryType.VIDEO,
                    ),
                  if (model.galleryVideoData.isEmpty)
                    Text(
                      "Tidak ada video untuk riwayat pemeliharaan ini.",
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.lightBlack01,
                        fontWeight: 500,
                      ),
                    ),
                  Spacings.vert(32),
                  const Divider(
                    thickness: 0.5,
                    color: MyColors.lightBlack02,
                  ),
                  Spacings.vert(32),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Dirawat oleh",
                      style: buildTextStyle(
                        fontSize: 18,
                        fontColor: MyColors.lightBlack02,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                  Spacings.vert(12),
                  TextInput.disabled(
                    label: "Nama Teknisi:",
                    text: model.historyMaintenanceData?.userName,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "No Telepon:",
                    text: model.historyMaintenanceData?.phoneNumber,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
