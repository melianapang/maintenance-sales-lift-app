import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:video_compress/video_compress.dart';

class FilesCompressionUtils {
  //compress image
  static Future<File> compressAndGetFileImage(XFile file) async {
    final absolutePath =
        await LecleFlutterAbsolutePath.getAbsolutePath(uri: file.path) ??
            file.path;

    print("before image compression: ${await File(file.path).lengthSync()}");
    final lastIdxPath = absolutePath.lastIndexOf(RegExp(r'.png|.jpg|.jpeg'));
    final splitted = absolutePath.substring(0, (lastIdxPath));
    final targetPath =
        '${splitted}_compressed${absolutePath.substring(lastIdxPath)}';

    File? result = await FlutterImageCompress.compressAndGetFile(
      absolutePath,
      targetPath,
      quality: 50,
    );

    print("after image compression: ${result?.lengthSync()}");
    return result ?? File(targetPath);
  }

  //compress video
  static Future<MediaInfo> compressAndGetFileVideo(XFile file) async {
    final absolutePath =
        await LecleFlutterAbsolutePath.getAbsolutePath(uri: file.path) ??
            file.path;

    print("before video compression: ${await File(file.path).lengthSync()}");
    final info = await VideoCompress.compressVideo(
      absolutePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    print("after video compression: ${info?.filesize}");
    return info ?? MediaInfo(path: file.path);
  }

  static Future<File> generateVideoThumbnail(String videoPath) async {
    return await VideoCompress.getFileThumbnail(
      videoPath,
      quality: 50,
      position: -1,
    );
  }

  static Future<void> cancelCompressVideo() async {
    VideoCompress.cancelCompression();
  }
}
