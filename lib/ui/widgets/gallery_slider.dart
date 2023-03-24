import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

class GallerySlider extends StatefulWidget {
  const GallerySlider({
    required this.urls,
    required this.pageController,
    super.key,
  });

  final List<String> urls;
  final PageController pageController;

  @override
  State<GallerySlider> createState() => _GallerySliderState();
}

class _GallerySliderState extends State<GallerySlider> {
  int _currentPage = 0;
  // {
  //   if (!_isInitialized) {
  //     return widget.pageController.initialPage + 1;
  //   }
  //   return (widget.pageController.page?.toInt() ?? 0) + 1;
  // }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageController.initialPage + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.darkBlack01,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '$_currentPage/${widget.urls.length}',
              style: buildTextStyle(
                fontSize: 16,
                fontWeight: 600,
                fontColor: MyColors.white,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: widget.pageController,
              itemCount: widget.urls.length,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value + 1;
                });
              },
              itemBuilder: (context, index) {
                return _buildImage(widget.urls[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return PhotoView(
      imageProvider: NetworkImage(url),
    );
  }
}
