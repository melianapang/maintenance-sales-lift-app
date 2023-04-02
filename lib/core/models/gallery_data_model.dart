class GalleryData {
  GalleryData({
    required this.filepath,
    required this.galleryType,
    this.thumbnailPath,
    this.isGalleryPicked = false,
  });

  final String filepath;
  final GalleryType galleryType;
  final String? thumbnailPath;
  final bool isGalleryPicked;
}

enum GalleryType { PHOTO, VIDEO }
