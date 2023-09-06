import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _busy = false;
  bool isDisposed = false;

  bool get busy => _busy;

  String errorMessage = '';

  void setBusy(
    bool value, {
    bool skipNotifyListener = false,
  }) {
    _busy = value;
    if (!isDisposed && !skipNotifyListener) {
      notifyListeners();
    }
  }

  dynamic initModel() {}

  bool hasError = false;
  void Function()? toRetry;

  void retry() {
    hasError = false;
    notifyListeners();
    toRetry!();
  }

  void handleError(Function()? toRetryFunc) {
    hasError = true;
    toRetry = toRetryFunc;
  }

  @override
  void dispose() {
    log('Model disposed: $runtimeType');
    isDisposed = true;
    super.dispose();
  }

  void mappingDioError(DioError dioError) {
    const String connectionFailedLabel = 'Koneksi sedang bermasalah';
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorMessage = 'Koneksi Time Out';
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        errorMessage = connectionFailedLabel;
        break;
      case DioExceptionType.badCertificate:

        /// need to mapping error
        errorMessage = connectionFailedLabel;
        break;
      case DioExceptionType.connectionTimeout:
        break;
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.badResponse:
        break;
      case DioExceptionType.connectionError:
        break;
      case DioExceptionType.unknown:
        break;
    }
  }
}
