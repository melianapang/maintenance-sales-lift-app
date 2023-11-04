import 'dart:io';
import 'package:alice_lightweight/core/alice_core.dart';
import 'package:alice_lightweight/core/alice_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rejo_jaya_sakti_apps/core/services/global_config_service.dart';

class DioService {
  DioService({
    required AliceCore aliceCore,
    required AuthenticationService authenticationService,
    required GlobalConfigService globalConfigService,
  })  : _aliceCore = aliceCore,
        _authenticationService = authenticationService,
        _globalConfigService = globalConfigService;

  static CancelToken _cancelToken = CancelToken();
  static const int _timeOut = 10000;

  Map<String, int> retryCounter = <String, int>{};

  static void printLogs(dynamic args) {
    debugPrint(args);
  }

  final AliceCore _aliceCore;
  final AuthenticationService _authenticationService;
  final GlobalConfigService _globalConfigService;

  String? get _customBaseURL => _globalConfigService.customBaseURL;

  Dio _makeBaseDio() {
    return Dio()
      ..options.baseUrl = _customBaseURL ?? EnvConstants.baseURL
      ..options.connectTimeout = const Duration(milliseconds: _timeOut)
      ..options.sendTimeout = const Duration(milliseconds: _timeOut)
      ..options.receiveTimeout = const Duration(milliseconds: _timeOut)
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
          onError: (e, handler) async {
            bool isLoggedIn = await _authenticationService.isLoggedIn();
            if (e.response?.statusCode == 401 && isLoggedIn) {
              _authenticationService.logout();
              return;
            }

            if (e.response != null) {
              handler.resolve(e.response!);
            } else {
              handler.next(e);
            }
            throw e;
          },
          onRequest: (
            RequestOptions option,
            RequestInterceptorHandler handler,
          ) async {
            final String? jwtToken = await _authenticationService.getJwtToken();

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
