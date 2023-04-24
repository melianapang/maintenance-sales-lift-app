import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';

class DownloadService {
  DownloadService({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  Future<String> downloadData({
    required String prefixString,
    required String filePath,
  }) async {
    final storageIO = InternetFileStorageIO();

    final jwtToken = await _authenticationService.getJwtToken();

    final currDateString = DateTimeUtils.convertDateToString(
      date: DateTime.now(),
      formatter: DateFormat(DateTimeUtils.DATE_FORMAT_3),
    );

    // final finalFileName = "${prefixString}_${currDateString}_exported.pdf";
    final finalFileName = "${prefixString}_${currDateString}_exported.xlsx";

    await InternetFile.get(
      filePath,
      // 'http://www.africau.edu/images/default/sample.pdf',
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

  Future<void> openDownloadedData({required String fileName}) async {
    // var filePath = r'/storage/emulated/0/update.apk';
    final openFile =
        await OpenFilex.open("/storage/emulated/0/Download/$fileName");
    print("type=${openFile.type}  message=${openFile.message}");
  }
}
