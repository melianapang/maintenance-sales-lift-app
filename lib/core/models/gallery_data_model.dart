class GalleryData {
  GalleryData({
    required this.filepath,
    required this.galleryType,
    this.isGalleryPicked = false,
  });

  final String filepath;
  final GalleryType galleryType;
  final bool isGalleryPicked;
}

enum GalleryType { PHOTO, VIDEO }
