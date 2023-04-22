import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:retrofit/dio.dart';

class ErrorUtils<T> {
  Left<Failure, T> handleError(Object error) {
    if (error is DioError) {
      String message = "";
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
          message = 'Tolong cek koneksi internet anda lagi.';
          break;
        case DioErrorType.other:
          if (error.message.contains("Network is unreachable")) {
            message = 'Tolong cek koneksi internet anda lagi.';
            break;
          } else if (error.message.contains("SocketException")) {
            message =
                'Koneksi Server sedang bermasalah. Coba beberapa saat lagi.';
            break;
          }
          message = error.message;
          break;
        case DioErrorType.response:
          message = error.message;
          break;
        case DioErrorType.cancel:
          break;
      }
      log('Failure: ${error.type.toString()}');
      return Left<Failure, T>(
        Failure(
          message: message,
        ),
      );
    }

    if (error is TypeError) {
      debugPrint(error.stackTrace.toString());
      log('Failure: TypeError');
      return Left<Failure, T>(
        Failure(
          message: 'TypeError',
        ),
      );
    }

    log('Failure: Unexpected Error');
    debugPrint(error.toString());
    return Left<Failure, T>(
      Failure(
        message: 'Unexpected Error',
      ),
    );
  }

  Left<Failure, T> handleDomainError(
    HttpResponse<dynamic> response, {
    String? message,
  }) {
    final Failure failure = Failure(
      errorCode: response.response.statusCode,
      message: message ?? response.data['Message'],
    );
    log('Failure: ${failure.errorCode} | ${failure.message}');
    return Left<Failure, T>(failure);
  }
}
