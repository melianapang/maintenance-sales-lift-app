import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/image_detail_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/gallery_slider.dart';

class ImageDetailViewParam {
  ImageDetailViewParam({
    this.initialIndex = 0,
    this.imageURLs,
  });

  final int initialIndex;
  final List<String>? imageURLs;
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
            title: 'Image Detail',
            isBackEnabled: true,
          ),
          body: model.busy
              ? _buildLoadingPage()
              : GallerySlider(
                  urls: param.imageURLs ?? [],
                  pageController: model.pageController,
                ),
        );
      },
    );
  }

  Widget _buildLoadingPage() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
