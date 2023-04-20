import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailHistoryMaintenanceViewModel extends BaseViewModel {
  DetailHistoryMaintenanceViewModel({
    required HistoryMaintenanceData? historyMaintenanceData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _historyMaintenanceData = historyMaintenanceData;

  final ApiService _apiService;

  HistoryMaintenanceData? _historyMaintenanceData;
  HistoryMaintenanceData? get historyMaintenanceData => _historyMaintenanceData;

  List<GalleryData> _galleryPhotoData = [];
  List<GalleryData> get galleryPhotoData => _galleryPhotoData;

  List<GalleryData> _galleryVideoData = [];
  List<GalleryData> get galleryVideoData => _galleryVideoData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setGalleryData();
    setBusy(false);
  }

  void setGalleryData() {
    if (_historyMaintenanceData?.maintenanceFiles?.isEmpty == true ||
        _historyMaintenanceData?.maintenanceFiles == null) return;

    for (int i = 0;
        i < (_historyMaintenanceData?.maintenanceFiles?.length ?? 0);
        i++) {
      if (_historyMaintenanceData?.maintenanceFiles?[i].fileType == "1") {
        _galleryPhotoData.add(
          GalleryData(
            filepath:
                _historyMaintenanceData?.maintenanceFiles?[i].filePath ?? "",
            galleryType: GalleryType.PHOTO,
          ),
        );
        continue;
      }

      _galleryVideoData.add(
        GalleryData(
          filepath:
              _historyMaintenanceData?.maintenanceFiles?[i].filePath ?? "",
          galleryType: GalleryType.VIDEO,
        ),
      );
    }
  }
}
