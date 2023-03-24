import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rejo_jaya_sakti_apps/core/models/login/login_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @POST('/project-lift/api/0/Auth/login')
  Future<HttpResponse<dynamic>> requestLogin(
    @Body() LoginRequest request,
  );
}

class ApiService {
  ApiService({
    required this.api,
  });

  final Api api;

  Future<String?> requestLogin(
      {required String inputUser, required String password}) async {
    try {
      final payload = LoginRequest(inputUser: inputUser, password: password);
      final HttpResponse<dynamic> response = await api.requestLogin(payload);

      if (response.response.statusCode == 200) {
        LoginResponse loginResponse =
            LoginResponse.fromJson(response.response.extra);
        return loginResponse.data.token;
      }
      return null;
    } catch (e) {
      log("Sequence number error");
      return null;
    }
  }
}
