import 'dart:io';
import 'package:dio/dio.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';

class DownloadService {
  DownloadService({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  Future<String> downloadExportedData({
    required String prefixString,
    required String filePath,
    String extension = "xlsx",
  }) async {
    final storageIO = InternetFileStorageIO();

    final jwtToken = await _authenticationService.getJwtToken();

    final currDateString = DateTimeUtils.convertDateToString(
      date: DateTime.now(),
      formatter: DateFormat(DateTimeUtils.DATE_FORMAT_2),
    );

    // final finalFileName = "${prefixString}_${currDateString}_exported.pdf";
    final finalFileName =
        "${prefixString}_${currDateString}_exported.$extension";

    await InternetFile.get(
      filePath,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      storage: storageIO,
      storageAdditional: storageIO.additional(
        filename: finalFileName,
        location: '/storage/emulated/0/Download/',
      ),
      force: true,
      progress: (receivedLength, contentLength) {
        final percentage = receivedLength / contentLength * 100;
        print(
            'download progress: $receivedLength of $contentLength ($percentage%)');
      },
    );

    return finalFileName;
  }

  Future<OpenResult> openDownloadedData({
    required String fileName,
  }) async {
    // var filePath = r'/storage/emulated/0/update.apk';
    final openFile = await OpenFilex.open(
      "/storage/emulated/0/Download/$fileName",
    );
    print("type=${openFile.type}  message=${openFile.message}");
    return openFile;
  }

  //region PDF
  //After uploading the PDF to GCS, we got downloadLink that will be used in downloadFile below.
  //when we use downloadLink, it means the file will be automatically downloaded to temporary storage when access the link.
  //user will be asked to download permanent when the PDF document already opened.
  //Compare to video and photos, after we upload them to GCS, we wont be used the downloadLink,
  //because we only need to show to the user the photo/video. We dont need to download it.
  Future<String> setFilePath(String fileName) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    }

    if (!Directory('${dir!.path}').existsSync()) {
      Directory('${dir.path}').createSync(recursive: true);
    }

    return '${dir.path}/$fileName';
  }

  Future<bool> downloadFile(String fileUrl, String savedPath) async {
    try {
      final Dio dio = Dio();
      final Response<dynamic> response = await dio.get(
        fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (int? status) {
            return status == 200;
          },
        ),
      );

      final File file = File(savedPath);
      final RandomAccessFile raf = file.openSync(mode: FileMode.write);

      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print("error download: ${e}");
      return false;
    }

    return true;
  }

  bool isFileExist({
    required String filePath,
  }) {
    final String savedFileDirectory =
        filePath.substring(0, filePath.lastIndexOf('/'));
    final bool directoryExists = Directory(savedFileDirectory).existsSync();
    final bool fileExists = File(filePath).existsSync();
    return directoryExists && fileExists;
  }

  Future<OpenResult> openPdfData({
    required String fileName,
    String? type,
  }) async {
    final openFile = await OpenFilex.open(
      fileName,
      type: type,
    );
    print("type=${openFile.type}  message=${openFile.message}");
    return openFile;
  }
  //endregion
}
