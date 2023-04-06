import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:retrofit/dio.dart';

class ErrorUtils<T> {
  Left<Failure, T> handleError(Object error) {
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
