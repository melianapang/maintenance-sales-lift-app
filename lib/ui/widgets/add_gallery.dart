import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

class AddGalleryThumbnailWidget extends StatelessWidget {
  AddGalleryThumbnailWidget({
    required this.galleryData,
    required this.callbackGalleryPath,
    required this.callbackDeleteAddedGallery,
    super.key,
  });

  final List<GalleryData> galleryData;
  final void Function(String path) callbackGalleryPath;
  final void Function(GalleryData data) callbackDeleteAddedGallery;

  Widget _buildGalleryThumbnail(
    GalleryData data, {
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
                    )
                  : Image.file(
                      File(data.filepath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 0,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(
                  4,
                ),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: const Icon(
                  PhosphorIcons.xBold,
                  size: 16,
                  color: MyColors.darkBlue01,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback _onTapAddGallery(BuildContext context,
      {required void Function(String path) callback}) {
    return () async {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) callback(image.path);
      // // Capture a photo
      // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      // // Pick multiple images
      // final List<XFile>? images = await _picker.pickMultiImage();
    };
  }

  Widget _buildAddGallery(BuildContext context) {
    return GestureDetector(
      onTap: _onTapAddGallery(context, callback: callbackGalleryPath),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          top: 12,
          left: 10,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: MyColors.white,
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
            fontColor: MyColors.greyColor,
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
        itemCount: galleryData.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == galleryData.length) {
            return _buildAddGallery(context);
          }
          return _buildGalleryThumbnail(
            galleryData[index],
            onTap: () {},
            onDelete: () {
              callbackDeleteAddedGallery(galleryData[index]);
            },
          );
        },
      ),
    );
  }
}
