import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/files_compression_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/image_detail_view.dart';
import 'package:video_compress/video_compress.dart';

class GalleryThumbnailWidget extends StatefulWidget {
  const GalleryThumbnailWidget({
    required this.galleryData,
    required this.galleryType,
    this.scrollController,
    this.callbackCompressedFiles,
    this.callbackDeleteAddedGallery,
    this.initialIndex = 0,
    this.isCRUD = true,
    super.key,
  });

  final List<GalleryData> galleryData;
  final GalleryType galleryType;
  final ScrollController? scrollController;
  final void Function(
    GalleryData? compressedFile,
    bool isCompressing,
  )? callbackCompressedFiles;
  final void Function(GalleryData data)? callbackDeleteAddedGallery;
  final int initialIndex;
  final bool isCRUD;

  @override
  State<GalleryThumbnailWidget> createState() => _GalleryThumbnailWidgetState();
}

class _GalleryThumbnailWidgetState extends State<GalleryThumbnailWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: _galleryThumbnailsLength,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (widget.isCRUD) {
            if (index == widget.galleryData.length) {
              return _buildAddGallery(context);
            }
            return _buildGalleryThumbnail(
              widget.galleryData[index],
              onTap: () {
                if (!widget.isCRUD) {
                  Navigator.pushNamed(
                    context,
                    Routes.imageDetail,
                    arguments: ImageDetailViewParam(
                      urls: widget.galleryData.map((e) => e.filepath).toList(),
                      galleryType: widget.galleryType,
                      initialIndex: index,
                    ),
                  );
                  return;
                }
              },
              onDelete: () {
                if (widget.callbackDeleteAddedGallery != null) {
                  widget.callbackDeleteAddedGallery!(widget.galleryData[index]);
                }
              },
            );
          }

          //mode read
          if (index == 2 && widget.galleryData.length > 3) {
            return _buildGalleryThumbnail(
              widget.galleryData[index],
              hiddenGalleryCount: widget.galleryData.length - 2,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.imageDetail,
                  arguments: ImageDetailViewParam(
                    urls: widget.galleryData.map((e) => e.filepath).toList(),
                    galleryType: widget.galleryType,
                    initialIndex: index,
                  ),
                );
                return;
              },
            );
          }
          return _buildGalleryThumbnail(
            widget.galleryData[index],
            hiddenGalleryCount: null,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.imageDetail,
                arguments: ImageDetailViewParam(
                  urls: widget.galleryData.map((e) => e.filepath).toList(),
                  galleryType: widget.galleryType,
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

  Widget _showPhotoThumbnail(GalleryData data) {
    return !data.isGalleryPicked
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
          );
  }

  Widget _showVideoThumbnail(GalleryData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        widget.isCRUD
            ? Image.file(
                File(
                  data.thumbnailPath ?? '',
                ),
              )
            : Image.network(
                data.thumbnailPath ?? '',
                fit: BoxFit.cover,
              ),
      ],
    );
  }

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
              child: widget.galleryType == GalleryType.PHOTO
                  ? _showPhotoThumbnail(data)
                  : _showVideoThumbnail(data),
            ),
          ),
          if (widget.isCRUD)
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
          if (!widget.isCRUD && hiddenGalleryCount != null)
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
    required bool isPhoto,
    void Function(
      GalleryData? compressedFile,
      bool isCompressing,
    )?
        callbackCompressedFiles,
  }) async {
    //pick file (image / photo)
    final ImagePicker _picker = ImagePicker();
    final XFile? file;
    if (isPhoto) {
      file = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      file = await _picker.pickVideo(source: ImageSource.gallery);
    }

    //compress file
    if (file != null) {
      File? compressedImage;
      MediaInfo? compressedVideo;
      GalleryData? compressedFile;

      //loading state
      if (callbackCompressedFiles != null) {
        callbackCompressedFiles(
          null,
          true,
        );
      }

      //start compressing
      if (isPhoto) {
        compressedImage = await FilesCompressionUtils.compressAndGetFileImage(
          file,
        );
        compressedFile = GalleryData(
          galleryType: GalleryType.PHOTO,
          filepath: compressedImage.path,
          isGalleryPicked: true,
        );
      } else {
        compressedVideo = await FilesCompressionUtils.compressAndGetFileVideo(
          file,
        );
        final File thumbnailFile =
            await FilesCompressionUtils.generateVideoThumbnail(
          compressedVideo.path ?? "",
        );
        compressedFile = GalleryData(
          galleryType: GalleryType.VIDEO,
          filepath: compressedVideo.path ?? '',
          thumbnailPath: thumbnailFile.path,
          isGalleryPicked: true,
        );
      }

      //finish compressing
      if (callbackCompressedFiles != null) {
        callbackCompressedFiles(
          compressedFile,
          false,
        );
      }
    }
  }

  Widget _buildAddGallery(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapAddGallery(
        context,
        isPhoto: widget.galleryType == GalleryType.PHOTO,
        callbackCompressedFiles: widget.callbackCompressedFiles,
      ),
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

  int get _galleryThumbnailsLength => widget.isCRUD
      ? widget.galleryData.length + 1
      : (widget.galleryData.length >= 3 ? 3 : widget.galleryData.length);
}
