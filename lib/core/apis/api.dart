import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
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

  @PUT('/project-lift/api/0/Customer/update_customer/3')
  Future<HttpResponse<dynamic>> requestUpdateCustomer(
    @Body() UpdateCustomerRequest request,
  );

  // @GET('project-lift/api/0/Customer/get_all_customers/')
  // Future<HttpResponse<dynamic>> requestGetAllCustomer(
  //   @Query("page") int page,
  // );
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
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);

        return loginResponse.data.token;
      }
      return null;
    } catch (e) {
      log("Sequence number error; ${e.toString()}");
      return null;
    }
  }

  Future<bool> requestUpdateCustomer() async {
    try {
      final payload = UpdateCustomerRequest(
        customerName: "Nama",
        customerNumber: "DFnsajd",
        customerType: 0,
        email: "abc@gmail.com",
        phoneNumber: "081223423424",
        city: "Surabaya",
        companyName: "PT ABC",
        note: "Catatan",
        dataSource: 1,
        status: 0,
      );
      final HttpResponse<dynamic> response =
          await api.requestUpdateCustomer(payload);

      if (response.response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log("Sequence number error");
      return false;
    }
  }

  // Future<void> getAllCustomer() async {
  //   try {
  //     // final payload = UpdateCustomerRequest(
  //     //   customerName: "Nama",
  //     //   customerNumber: "DFnsajd",
  //     //   customerType: 0,
  //     //   email: "abc@gmail.com",
  //     //   phoneNumber: "081223423424",
  //     //   city: "Surabaya",
  //     //   companyName: "PT ABC",
  //     //   note: "Catatan",
  //     //   dataSource: 1,
  //     //   status: 0,
  //     // );
  //     // final HttpResponse<dynamic> response =
  //     //     await api.requestGetAllCustomer(payload);

  //     // if (response.response.statusCode == 200) {
  //     //   return true;
  //     // }
  //     // return false;
  //   } catch (e) {
  //     log("Sequence number error");
  //   }
  // }
}
