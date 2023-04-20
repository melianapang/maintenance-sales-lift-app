import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_result.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/status_card.dart';

class DetailHistoryFollowUpViewModel extends BaseViewModel {
  DetailHistoryFollowUpViewModel({
    HistoryFollowUpData? historyData,
  }) : _historyData = historyData;

  HistoryFollowUpData? _historyData;
  HistoryFollowUpData? get historyData => _historyData;

  StatusCardType _statusCardType = StatusCardType.Normal;
  StatusCardType get statusCardType => _statusCardType;

  List<GalleryData> _galleryData = [];
  List<GalleryData> get galleryData => _galleryData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    setStatusCard();
    setGalleryData();
    setBusy(false);
  }

  void setStatusCard() {
    FollowUpStatus status = FollowUpStatus.values[int.parse(
      _historyData?.followUpResult ?? "0",
    )];

    switch (status) {
      case FollowUpStatus.Loss:
        _statusCardType = StatusCardType.Loss;
        break;
      case FollowUpStatus.Win:
        _statusCardType = StatusCardType.Win;
        break;
      case FollowUpStatus.Hot:
        _statusCardType = StatusCardType.Hot;
        break;
      case FollowUpStatus.In_Progress:
      default:
        _statusCardType = StatusCardType.InProgress;
    }
  }

  void setGalleryData() {
    if (_historyData?.documents?.isEmpty == true ||
        _historyData?.documents == null) return;

    for (int i = 0; i < (_historyData?.documents?.length ?? 0); i++) {
      _galleryData.add(
        GalleryData(
          filepath: _historyData?.documents?[i].filePath ?? "",
          galleryType: GalleryType.PHOTO,
        ),
      );
    }
  }
}
