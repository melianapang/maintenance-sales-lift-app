import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:retrofit/dio.dart';

class ErrorUtils<T> {
  Left<Failure, T> handleError(Object error) {
    if (error is DioException) {
      String message = "";
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          message = 'Tolong cek koneksi internet anda lagi.';
          break;
        case DioExceptionType.unknown:
          if (error.message?.contains("Network is unreachable") == true) {
            message = 'Tolong cek koneksi internet anda lagi.';
            break;
          } else if (error.message?.contains("SocketException") == true) {
            message =
                'Koneksi Server sedang bermasalah. Coba beberapa saat lagi.';
            break;
          }
          message = error.message ?? "";
          break;
        case DioExceptionType.badResponse:
          message = error.message ?? "";
          break;
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.badCertificate:
          break;
        case DioExceptionType.connectionError:
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
