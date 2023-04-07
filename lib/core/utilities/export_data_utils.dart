import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';

class ExportDataUtils {
  static Future<String> exportData({
    required String prefixString,
    required String filePath,
  }) async {
    final storageIO = InternetFileStorageIO();

    final currDateString = DateTimeUtils.convertDateToString(
      date: DateTime.now(),
      formatter: DateFormat("ddMMMyyyy"),
    );
    final finalFileName = "${prefixString}_${currDateString}_exported.pdf";

    await InternetFile.get(
      filePath,
      // 'http://www.africau.edu/images/default/sample.pdf',
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

  static Future<void> openExportedData({required String fileName}) async {
    // var filePath = r'/storage/emulated/0/update.apk';
    final openFile =
        await OpenFilex.open("/storage/emulated/0/Download/$fileName");
    print("type=${openFile.type}  message=${openFile.message}");
  }
}
