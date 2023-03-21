import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

class ListGalleryThumbnailWidget extends StatelessWidget {
  const ListGalleryThumbnailWidget({super.key});

  Widget _buildGalleryThumbnail(
    GalleryData data, {
    int? hiddenGalleryCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                15,
              ),
              child: Image.network(
                data.filepath,
                width: 100,
                height: 100,
              ),
            ),
          ),
          if (hiddenGalleryCount != null)
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: MyColors.black.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              width: 100,
              height: 100,
              child: Text(
                "+$hiddenGalleryCount",
                style: buildTextStyle(
                  fontSize: 18,
                  fontColor: MyColors.white,
                  fontWeight: 600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<GalleryData> data = [
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      ),
      GalleryData(
        filepath:
            "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        galleryType: GalleryType.PHOTO,
      )
    ];

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        itemCount: data.length >= 3 ? 3 : data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == 2 && data.length > 3) {
            return _buildGalleryThumbnail(
              data[index],
              hiddenGalleryCount: data.length - 2,
              onTap: () {},
            );
          }
          return _buildGalleryThumbnail(
            data[index],
            hiddenGalleryCount: null,
            onTap: () {},
          );
        },
      ),
    );
  }
}
