import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/login/login_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  //region authentication
  @POST('/project-lift/api/0/Auth/login')
  Future<HttpResponse<dynamic>> requestLogin(
    @Body() LoginRequest request,
  );
  //endregion

  //region log
  @GET('/project-lift/api/0/Log/get_logs/')
  Future<HttpResponse<dynamic>> requestGetAllLog(
      // @Query("page") int page,
      );
  //endregion

  //region customer
  @PUT('/project-lift/api/0/Customer/update_customer/{customer_id}')
  Future<HttpResponse<dynamic>> requestUpdateCustomer(
    @Path("customer_id") int customerId,
    @Body() UpdateCustomerRequest request,
  );

  @GET('/project-lift/api/0/Customer/get_all_customers/')
  Future<HttpResponse<dynamic>> requestGetAllCustomer(
      // @Query("page") int page,
      );
  //endregion

  //region maintenance
  @GET('/project-lift/api/0/Maintenance/get_all_maintenances/')
  Future<HttpResponse<dynamic>> requestGetAllMaintenance(
      // @Query("page") int page,
      );

  @PUT('/project-lift/api/0/Customer/update_maintenance/{customer_id}')
  Future<HttpResponse<dynamic>> requestUpdateMaintenance(
    @Path("maintenance_id") int customerId,
    @Body() UpdateMaintenanceRequest request,
  );
  //endregion
}

class ApiService {
  ApiService({
    required this.api,
  });

  final Api api;

  //region authentication
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
  //endregion

  //region log
  Future<List<LogData>?> requestGetAllLog() async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllLog();

      if (response.response.statusCode == 200) {
        GetAllLogResponse getAllLog = GetAllLogResponse.fromJson(response.data);
        return getAllLog.data.result;
      }
      return null;
    } catch (e) {
      if (e is CastError) {
        print(e.stackTrace);
      }
      log(e.toString());
    }
  }
  //endregion

  //region customer
  Future<bool> requestUpdateCustomer({
    required String nama,
    required String customerNumber,
    required int customerType,
    required int customerId,
    required String customerNeed,
    required String email,
    required String companyName,
    required String phoneNumber,
    required String note,
    required int dataSource,
    required String city,
  }) async {
    try {
      final payload = UpdateCustomerRequest(
        customerName: nama,
        customerNumber: customerNumber,
        customerType: customerType,
        customerNeed: customerNeed,
        email: email,
        phoneNumber: phoneNumber,
        city: city,
        companyName: companyName,
        note: note,
        dataSource: dataSource,
        status: 0,
      );
      final HttpResponse<dynamic> response = await api.requestUpdateCustomer(
        customerId,
        payload,
      );

      if (response.response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log("Sequence number error");
      return false;
    }
  }

  Future<List<CustomerData>?> getAllCustomer() async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllCustomer();

      if (response.response.statusCode == 200) {
        GetAllCustomerResponse getAllResponse =
            GetAllCustomerResponse.fromJson(response.data);

        return getAllResponse.data.result;
      }
      return null;
    } catch (e) {
      log("Sequence number error");
    }
  }
  //endregion

  //region maintenance
  Future<List<MaintenanceData>?> requestGetAllMaintenance() async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllMaintenance();

      if (response.response.statusCode == 200) {
        GetAllMaintenanceResponse getAllMaintenanceResponse =
            GetAllMaintenanceResponse.fromJson(response.data);

        return getAllMaintenanceResponse.data.result;
      }
      return null;
    } catch (e) {
      log("Sequence number error");
    }
  }
  //endregion
}
