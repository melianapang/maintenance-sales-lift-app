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
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        errorMessage = 'Koneksi Time Out';
        break;
      case DioErrorType.cancel:
      case DioErrorType.other:
        errorMessage = connectionFailedLabel;
        break;
      case DioErrorType.response:

        /// need to mapping error
        errorMessage = connectionFailedLabel;
        break;
    }
  }
}
