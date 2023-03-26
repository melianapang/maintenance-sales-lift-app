import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

class ThumbnailVideoUtils {
  static FutureBuilder<ThumbnailResult> showThumbnailVideo(GalleryData data) {
    return FutureBuilder<ThumbnailResult>(
      future: generateVideoThumbnail(data.filepath),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _image,
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              "Error:\n${snapshot.error.toString()}",
            ),
          );
        } else {
          return buildLoadingSymbol();
        }
      },
    );
  }

  static Future<ThumbnailResult> generateVideoThumbnail(String fileUrl) async {
    final Completer<ThumbnailResult> completer = Completer();

    String? thumbnailFileName = await VideoThumbnail.thumbnailFile(
      video: fileUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 65,
    );

    final file = File(thumbnailFileName!);
    Uint8List bytes = file.readAsBytesSync();
    int _imageDataSize = bytes.length;
    print("image size: $_imageDataSize");

    final _image = Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailResult(
        image: _image,
        dataSize: _imageDataSize,
        height: info.image.height,
        width: info.image.width,
      ));
    }));

    return completer.future;
  }
}
