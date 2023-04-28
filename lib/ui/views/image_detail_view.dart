import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/image_detail_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery_slider.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/video_player_widget.dart';

class ImageDetailViewParam {
  ImageDetailViewParam({
    this.initialIndex = 0,
    this.galleryType = GalleryType.PHOTO,
    this.urls,
  });

  final int initialIndex;
  final GalleryType galleryType;
  final List<String>? urls;
}

class ImageDetailView extends StatelessWidget {
  const ImageDetailView({
    required this.param,
    super.key,
  });
  final ImageDetailViewParam param;

  @override
  Widget build(BuildContext context) {
    return ViewModel<ImageDetailViewModel>(
      model: ImageDetailViewModel(
        initialIndex: param.initialIndex,
      ),
      onModelReady: (model) => model.initModel(),
      builder: (_, model, __) {
        return Scaffold(
          appBar: buildDefaultAppBar(
            context,
            title: param.galleryType == GalleryType.PHOTO ||
                    param.galleryType == GalleryType.PDF
                ? 'Image Detail'
                : 'Video Detail',
            isBackEnabled: true,
          ),
          body: model.busy ? buildLoadingPage() : _buildDetailMedia(model),
        );
      },
    );
  }

  Widget _buildDetailMedia(ImageDetailViewModel model) {
    if (param.galleryType == GalleryType.PHOTO ||
        param.galleryType == GalleryType.PDF) {
      return GallerySlider(
        urls: param.urls ?? [],
        pageController: model.pageController,
      );
    }

    return VideoPlayerWidget(url: param.urls?.first ?? "");
  }
}
