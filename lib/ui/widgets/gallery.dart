import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/image_detail_view.dart';

class GalleryThumbnailWidget extends StatelessWidget {
  GalleryThumbnailWidget({
    required this.galleryData,
    this.scrollController,
    required this.callbackGalleryPath,
    required this.callbackDeleteAddedGallery,
    this.initialIndex = 0,
    this.isCRUD = true,
    super.key,
  });

  final List<GalleryData> galleryData;
  final ScrollController? scrollController;
  final void Function(String path) callbackGalleryPath;
  final void Function(GalleryData data) callbackDeleteAddedGallery;
  final int initialIndex;
  final bool isCRUD;

  Widget _buildGalleryThumbnail(
    GalleryData data, {
    int? hiddenGalleryCount,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 12,
              top: 12,
              bottom: 12,
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
              child: !data.isGalleryPicked
                  ? Image.network(
                      data.filepath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(data.filepath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (isCRUD)
            Positioned(
              top: 0,
              right: 4,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(
                    6,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.darkBlack02,
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  child: const Icon(
                    PhosphorIcons.xBold,
                    size: 12,
                    color: MyColors.white,
                  ),
                ),
              ),
            ),
          if (!isCRUD && hiddenGalleryCount != null)
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                right: 12,
                top: 12,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: MyColors.darkBlack02.withOpacity(
                  0.8,
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
                  fontColor: MyColors.yellow01,
                  fontWeight: 600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTapAddGallery(
    BuildContext context, {
    required void Function(String path) callback,
  }) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) callback(image.path);
    // // Capture a photo
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    // // Pick multiple images
    // final List<XFile>? images = await _picker.pickMultiImage();
  }

  Widget _buildAddGallery(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapAddGallery(context, callback: callbackGalleryPath),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          top: 12,
          left: 10,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: MyColors.darkBlack02,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        width: 100,
        height: 100,
        child: Text(
          "+",
          style: buildTextStyle(
            fontSize: 48,
            fontColor: MyColors.yellow01,
            fontWeight: 400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: ListView.builder(
        controller: scrollController,
        itemCount: _galleryThumbnailsLength,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (isCRUD) {
            if (index == galleryData.length) {
              return _buildAddGallery(context);
            }
            return _buildGalleryThumbnail(
              galleryData[index],
              onTap: () {
                if (!isCRUD) {
                  Navigator.pushNamed(
                    context,
                    Routes.imageDetail,
                    arguments: ImageDetailViewParam(
                      imageURLs: galleryData.map((e) => e.filepath).toList(),
                      initialIndex: index,
                    ),
                  );
                  return;
                }
              },
              onDelete: () {
                callbackDeleteAddedGallery(galleryData[index]);
              },
            );
          }

          //mode read
          if (index == 2 && galleryData.length > 3) {
            return _buildGalleryThumbnail(
              galleryData[index],
              hiddenGalleryCount: galleryData.length - 2,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.imageDetail,
                  arguments: ImageDetailViewParam(
                    imageURLs: galleryData.map((e) => e.filepath).toList(),
                    initialIndex: index,
                  ),
                );
                return;
              },
            );
          }
          return _buildGalleryThumbnail(
            galleryData[index],
            hiddenGalleryCount: null,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.imageDetail,
                arguments: ImageDetailViewParam(
                  imageURLs: galleryData.map((e) => e.filepath).toList(),
                  initialIndex: index,
                ),
              );
              return;
            },
          );
        },
      ),
    );
  }

  int get _galleryThumbnailsLength => isCRUD
      ? galleryData.length + 1
      : (galleryData.length >= 3 ? 3 : galleryData.length);
}
