import 'dart:io';
import 'package:alice_lightweight/core/alice_core.dart';
import 'package:alice_lightweight/core/alice_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/services/apis_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rxdart/subjects.dart';

class DioService {
  DioService({
    required AliceCore aliceCore,
    required ApisService apisService,
  })  : _aliceCore = aliceCore,
        _apisService = apisService;

  static CancelToken _cancelToken = CancelToken();
  static const int _timeOut = 10000;

  Map<String, int> retryCounter = <String, int>{};

  static void printLogs(dynamic args) {
    debugPrint(args);
  }

  final AliceCore _aliceCore;
  final ApisService _apisService;

  Dio _makeBaseDio() {
    return Dio()
      ..options.baseUrl = EnvConstants.baseURL
      ..options.connectTimeout = _timeOut
      // ..options.responseType = ResponseType.json
      ..interceptors.addAll(<Interceptor>[
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          request: true,
          responseHeader: true,
        ),
        AliceDioInterceptor(_aliceCore),
      ]);
  }

  Dio getDio() {
    final Dio baseDio = _makeBaseDio();

    return baseDio
      ..options.headers.addAll(
        <String, dynamic>{
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions option,
            RequestInterceptorHandler handler,
          ) async {
            option.cancelToken = _cancelToken;

            return handler.next(option);
          },
        ),
      );
  }

  Dio getDioJwt() {
    final Dio baseDio = _makeBaseDio();

    return baseDio
      ..options.headers.addAll(
        <String, dynamic>{
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions option,
            RequestInterceptorHandler handler,
          ) async {
            final String? jwtToken = await _apisService.getJwtToken();

            option.cancelToken = _cancelToken;

            if (option.headers.containsKey(HttpHeaders.authorizationHeader)) {
              option.headers.remove(HttpHeaders.authorizationHeader);
            }

            if (jwtToken != null) {
              option.headers[HttpHeaders.authorizationHeader] =
                  'Bearer $jwtToken';
            } else {
              _cancelToken.cancel(
                'LOGGED_OUT',
              );

              _cancelToken = CancelToken();
            }

            return handler.next(option);
          },
        ),
      );
  }

  void cancelAllRequest() {
    _cancelToken.cancel('MANUAL CANCEL');
    _cancelToken = CancelToken();
  }
}
