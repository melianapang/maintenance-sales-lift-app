import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/padding_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/detail_history_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/maintenance/detail_maintenance_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/map/map_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/buttons.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/text_inputs.dart';

class DetailHistoryMaintenanceViewParam {
  DetailHistoryMaintenanceViewParam({
    this.maintenanceData,
  });

  final MaintenanceData? maintenanceData;
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
  String nama = "Aldo AldoAldoo";
  String notelp = "081234567890";

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
        maintenanceData: widget.param?.maintenanceData,
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
              Navigator.pushNamed(context, Routes.map,
                  arguments: MapViewParam(
                    longitude:
                        double.parse(model.maintenanceData?.longitude ?? "0"),
                    latitude:
                        double.parse(model.maintenanceData?.latitude ?? "0"),
                  ));
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
                    model.maintenanceData?.unitName ?? "",
                    style: buildTextStyle(
                      fontSize: 32,
                      fontWeight: 800,
                      fontColor: MyColors.yellow01,
                    ),
                  ),
                  Text(
                    model.maintenanceData?.customerName ?? "",
                    style: buildTextStyle(
                      fontSize: 20,
                      fontWeight: 400,
                      fontColor: MyColors.lightBlack02,
                    ),
                  ),
                  Spacings.vert(35),
                  StatusCardWidget(
                    cardType: StatusCardType.Confirmed,
                    onTap: () {},
                  ),
                  Spacings.vert(35),
                  TextInput.disabled(
                    label: "Tanggal",
                    text: model.maintenanceData?.endMaintenance,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Hasil Pemeliharaan",
                    text: model.maintenanceData?.maintenanceResult,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "Catatan",
                    text: model.maintenanceData?.note,
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
                  GalleryThumbnailWidget(
                    isCRUD: false,
                    galleryData: videoData,
                    galleryType: GalleryType.VIDEO,
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
                    text: model.maintenanceData?.engineerName,
                  ),
                  Spacings.vert(24),
                  TextInput.disabled(
                    label: "No Telepon:",
                    text: model.maintenanceData?.engineerPhoneNumber,
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
