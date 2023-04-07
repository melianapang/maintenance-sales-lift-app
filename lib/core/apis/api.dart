import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:rejo_jaya_sakti_apps/core/models/authentication/login_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/authentication/manage_account_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_data.dart';
import 'package:rejo_jaya_sakti_apps/core/models/utils/error_utils.dart';
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

  @PUT('/project-lift/api/0/Auth/update_password/')
  Future<HttpResponse<dynamic>> requestChangePassword(
    @Body() ChangePasswordRequest request,
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
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );
  //endregion

  //region maintenance
  @GET('/project-lift/api/0/Maintenance/get_all_maintenances/')
  Future<HttpResponse<dynamic>> requestGetAllMaintenance(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/project-lift/api/0/Maintenance/get_history_maintenances/{unit_id}')
  Future<HttpResponse<dynamic>> requestGetAllHistoryMaintenance(
    @Path("unit_id") String customerId,
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
  Future<Either<Failure, String>> requestLogin(
      {required String inputUser, required String password}) async {
    try {
      final payload = LoginRequest(inputUser: inputUser, password: password);
      final HttpResponse<dynamic> response = await api.requestLogin(payload);

      if (response.isSuccess) {
        final LoginResponse loginResponse = LoginResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(loginResponse.data.token);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Sequence number error; ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestChangePassword({
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final payload = ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      final HttpResponse<dynamic> response =
          await api.requestChangePassword(payload);

      if (response.response.statusCode == 200) {
        ChangePasswordResponse changePasswordResponse =
            ChangePasswordResponse.fromJson(response.data);

        return Right<Failure, bool>(changePasswordResponse.isSuccess);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<bool>().handleError(e);
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

  Future<List<CustomerData>?> getAllCustomer(
    int currentPage,
    int pageSize,
  ) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllCustomer(
        currentPage,
        pageSize,
      );

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

  Future<String> requestExportCustomerData() async {
    return 'http://www.africau.edu/images/default/sample.pdf';
  }
  //endregion

  //region maintenance
  Future<List<MaintenanceData>?> requestGetAllMaintenance(
    int currentPage,
    int pageSize,
  ) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllMaintenance(
        currentPage,
        pageSize,
      );

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

  Future<List<MaintenanceData>?> requestGetAllHistoryMaintenance(
    String unitId,
  ) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllHistoryMaintenance(
        unitId,
      );

      if (response.response.statusCode == 200) {
        GetAllHistoryMaintenanceResponse getAllHistoryMaintenanceResponse =
            GetAllHistoryMaintenanceResponse.fromJson(response.data);

        return getAllHistoryMaintenanceResponse.data.result;
      }
      return null;
    } catch (e) {
      log("Sequence number error");
    }
  }
  //endregion

  //region projects

  Future<List<ProjectData>?> getAllProjects(
    int currentPage,
    int pageSize,
  ) async {
    return [];
    // try {
    // final HttpResponse<dynamic> response = await api.requestGetAllCustomer(
    //   currentPage,
    //   pageSize,
    // );

    // if (response.response.statusCode == 200) {
    // GetAllCustomerResponse getAllResponse =
    // GetAllCustomerResponse.fromJson(response.data);

    // return getAllResponse.data.result;
    //   }
    //   return null;
    // } catch (e) {
    //   log("Sequence number error");
    // }
  }
  //endregion
}

extension ParsedResponse<T> on HttpResponse<T> {
  bool get isSuccess =>
      <int>[
        HttpStatus.ok,
        HttpStatus.created,
        HttpStatus.accepted,
      ].contains(response.statusCode) &&
      response.data['Success'] == true;

  Failure? get failure {
    if (isSuccess) return null;
    return Failure(
      message: response.data['Message'],
      errorCode: response.statusCode,
    );
  }
}
