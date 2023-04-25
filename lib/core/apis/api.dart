import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:rejo_jaya_sakti_apps/core/models/approval/approval_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/authentication/login_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/authentication/manage_account_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/document/document_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/follow%20up/follow_up_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/log/log_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/reminder/reminder_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/utils/error_utils.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  //region authentication
  @POST('/api/0/Auth/login')
  Future<HttpResponse<dynamic>> requestLogin(
    @Body() LoginRequest request,
  );

  @PUT('/api/0/Auth/update_password/')
  Future<HttpResponse<dynamic>> requestChangePassword(
    @Body() ChangePasswordRequest request,
  );
  //endregion

  //region user
  @GET('/api/0/User/get_all_users/')
  Future<HttpResponse<dynamic>> requestGetAllUser(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/User/search_user/')
  Future<HttpResponse<dynamic>> searchUser(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @POST('/api/0/User/create_user')
  Future<HttpResponse<dynamic>> requestCreateUser(
    @Body() CreateUserRequest request,
  );

  @PUT('/api/0/User/update_user/{user_id}')
  Future<HttpResponse<dynamic>> requestUpdateUser(
    @Path("user_id") int userId,
    @Body() UpdateUserRequest request,
  );

  @DELETE('/api/0/User/delete_user/{user_id}')
  Future<HttpResponse<dynamic>> requestDeleteUser(
    @Path("user_id") int userId,
  );

  @GET('/api/0/User/get_user_detail/{user_id}')
  Future<HttpResponse<dynamic>> requestGetUserDetail(
    @Path("user_id") int userId,
  );
  //endregion

  //region approval
  @GET('/api/0/Approval/get_all_approvals/')
  Future<HttpResponse<dynamic>> requestGetAllApproval(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Approval/get_approval_detail/{approval_id}')
  Future<HttpResponse<dynamic>> requestGetApprovalDetail(
    @Path("approval_id") int approvalId,
  );

  @PUT('/api/0/Approval/update_approval/{approval_id}')
  Future<HttpResponse<dynamic>> requestUpdateApproval(
    @Path("approval_id") int approvalId,
    @Body() UpdateApprovalRequest request,
  );
  //endregion

  //region log
  @GET('/api/0/Log/get_logs/')
  Future<HttpResponse<dynamic>> requestGetAllLog(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Log/search_log/')
  Future<HttpResponse<dynamic>> searchLog(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @GET('/api/0/Log/get_log_detail/{log_id}')
  Future<HttpResponse<dynamic>> requestGetLogDetail(
    @Path("log_id") int logId,
  );
  //endregion

  //region reminder
  @GET('/api/0/Reminder/get_all_reminders/')
  Future<HttpResponse<dynamic>> requestGetAllReminder(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Reminder/search_reminder/')
  Future<HttpResponse<dynamic>> searchReminder(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @POST('/api/0/Reminder/create_reminder')
  Future<HttpResponse<dynamic>> requestCreateReminder(
    @Body() CreateReminderRequest request,
  );

  @PUT('/api/0/Reminder/update_reminder/{reminder_id}')
  Future<HttpResponse<dynamic>> requestUpdateReminder(
    @Path("reminder_id") int reminderId,
    @Body() UpdateReminderRequest request,
  );

  @DELETE('/api/0/Reminder/delete_reminder/{reminder_id}')
  Future<HttpResponse<dynamic>> requestDeleteReminder(
    @Path("reminder_id") int reminderId,
  );

  @GET('/api/0/Reminder/get_detail_reminder/{reminder_id}')
  Future<HttpResponse<dynamic>> requestGetDetailReminder(
    @Path("reminder_id") int reminderId,
  );
  //endregion

  //region customer
  @POST('/api/0/Customer/create_customer')
  Future<HttpResponse<dynamic>> requestCreateCustomer(
    @Body() CreateCustomerRequest request,
  );

  @PUT('/api/0/Customer/update_customer/{customer_id}')
  Future<HttpResponse<dynamic>> requestUpdateCustomer(
    @Path("customer_id") int customerId,
    @Body() UpdateCustomerRequest request,
  );

  @DELETE('/api/0/Customer/delete_customer/{customer_id}')
  Future<HttpResponse<dynamic>> requestDeleteCustomer(
    @Path("customer_id") int customerId,
  );

  @GET('/api/0/Customer/get_all_customers/')
  Future<HttpResponse<dynamic>> requestGetAllCustomer(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Customer/get_customer_detail/{customer_id}')
  Future<HttpResponse<dynamic>> requestGetDetailCustomer(
    @Path("customer_id") int customerId,
  );

  @GET('/api/0/Customer/search_customer/')
  Future<HttpResponse<dynamic>> searchCustomer(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @GET('/api/0/Customer/filter_customer/')
  Future<HttpResponse<dynamic>> requestFilterCustomer(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("customer_type") int customerType,
    @Query("data_source") int dataSource,
    @Query("customer_need") int customerNeed,
    @Query("sort_by") int sortBy,
  );
  //endregion

  //region unit
  @GET('/api/0/Customer/search_customer/')
  Future<HttpResponse<dynamic>> searchUnit(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @GET('/api/0/Unit/get_all_units/{customer_id}')
  Future<HttpResponse<dynamic>> requestGetAllUnitByCustomer(
    @Path("customer_id") int customerId,
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @POST('/api/0/Unit/create_unit')
  Future<HttpResponse<dynamic>> requestCreateUnit(
    @Body() CreateUnitRequest request,
  );

  @PUT('/api/0/Unit/update_unit/{unit_id}')
  Future<HttpResponse<dynamic>> requestUpdateUnit(
    @Path("unit_id") int unitId,
    @Body() UpdateUnitRequest request,
  );

  @DELETE('/api/0/Unit/delete_unit/{unit_id}')
  Future<HttpResponse<dynamic>> requestDeleteUnit(
    @Path("unit_id") int unitId,
  );

  @GET('/api/0/Unit/get_unit_detail/{unit_id}')
  Future<HttpResponse<dynamic>> requestGetDetailUnit(
    @Path("unit_id") int unitId,
  );
  //endregion

  //region follow up
  @GET('/api/0/FollowUp/get_all_follow_ups/')
  Future<HttpResponse<dynamic>> requestGetAllFollowUp(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/FollowUp/get_detail_follow_up/{follow_up_id}')
  Future<HttpResponse<dynamic>> requestGetFollowUpDetail(
    @Path("follow_up_id") int followUpId,
  );

  @GET('/api/0/FollowUp/get_history_follow_ups/{customer_id}')
  Future<HttpResponse<dynamic>> requestGetAllHistoryFollowUp(
    @Path("customer_id") String customerId,
  );

  @GET('/api/0/FollowUp/search_follow_up/')
  Future<HttpResponse<dynamic>> searchFollowUp(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @POST('/api/0/FollowUp/create_follow_up/')
  Future<HttpResponse<dynamic>> requestCreateFollowUp(
    @Body() CreateFollowUpRequest request,
  );

  @PUT('/api/0/FollowUp/update_follow_up/{follow_up_id}')
  Future<HttpResponse<dynamic>> requestUpdateFollowUp(
    @Path("follow_up_id") int followUpId,
    @Body() UpdateFollowUpRequest request,
  );
  //endregion

  //region document
  @POST('/api/0/Document/create_document')
  Future<HttpResponse<dynamic>> requestCreateDocument(
    @Body() CreateDocumentRequest request,
  );
  //enregion

  //region maintenance
  @GET('/api/0/Maintenance/get_all_maintenances/')
  Future<HttpResponse<dynamic>> requestGetAllMaintenance(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Maintenance/get_detail_maintenance/{maintenance_id}')
  Future<HttpResponse<dynamic>> requestGetMaintenanceDetail(
    @Path("maintenance_id") int maintenanceId,
  );

  @GET('/api/0/Maintenance/get_history_maintenances/{unit_id}')
  Future<HttpResponse<dynamic>> requestGetAllHistoryMaintenance(
    @Path("unit_id") String customerId,
  );

  @GET('/api/0/Maintenance/search_maintenance/')
  Future<HttpResponse<dynamic>> searchMaintenance(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @POST('project-lift/api/0/Maintenance/create_maintenance')
  Future<HttpResponse<dynamic>> requestCreateMaintenance(
    @Body() CreateMaintenanceRequest request,
  );

  @PUT('/api/0/Maintenance/update_maintenance/{maintenance_id}')
  Future<HttpResponse<dynamic>> requestUpdateMaintenance(
    @Path("maintenance_id") int maintenanceId,
    @Body() UpdateMaintenanceRequest request,
  );

  @PUT('/api/0/Maintenance/change_maintenance_date/{maintenance_id}')
  Future<HttpResponse<dynamic>> requestChangeeMaintenanceDate(
    @Path("maintenance_id") int maintenanceId,
    @Body() ChangeMaintenanceDateRequest request,
  );

  @DELETE('/api/0/Maintenance/delete_maintenance/{maintenance_id}')
  Future<HttpResponse<dynamic>> requestDeleteMaintenance(
    @Path("maintenance_id") int maintenanceId,
    @Body() DeleteMaintenanceRequest request,
  );

  @GET('/api/0/Maintenance/filter_maintenance/')
  Future<HttpResponse<dynamic>> requestFilterMaintenance(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("status") int status,
    @Query("sort_by") int sortBy,
  );
  //endregion

  //region project
  @GET('/api/0/Project/get_all_projects/')
  Future<HttpResponse<dynamic>> requestGetAllProjects(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Project/get_all_projects_by_customer_id/{customer_id}')
  Future<HttpResponse<dynamic>> requestGetAllProjectsByCustomerId(
    @Path("customer_id") int customerId,
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
  );

  @GET('/api/0/Project/get_project_detail/{project_id}')
  Future<HttpResponse<dynamic>> requestProjectDetail(
    @Path("project_id") int projectId,
  );

  @GET('/api/0/Project/search_project/')
  Future<HttpResponse<dynamic>> searchProject(
    @Query("current_page") int currentPage,
    @Query("page_size") int pageSize,
    @Query("input_search") String inputSearch,
  );

  @POST('/api/0/Project/create_project')
  Future<HttpResponse<dynamic>> requestCreateProject(
    @Body() CreateProjectRequest request,
  );

  @POST('/api/0/Pic/create_pic/')
  Future<HttpResponse<dynamic>> requestCreatePICProject(
    @Body() List<CreatePICProjectRequest> request,
  );

  @DELETE('/api/0/Pic/delete_pic/{pic_id}')
  Future<HttpResponse<dynamic>> requestDeletePICProject(
    @Path("pic_id") int picId,
  );

  @PUT('/api/0/Project/update_project/{project_id}')
  Future<HttpResponse<dynamic>> requestUpdateProject(
    @Path("project_id") int projectId,
    @Body() UpdateProjectRequest request,
  );

  @DELETE('/api/0/Project/delete_project/{project_id}')
  Future<HttpResponse<dynamic>> requestDeleteProject(
    @Path("project_id") int projectId,
  );

  @GET('/api/0/Project/get_project_detail/{project_id}')
  Future<HttpResponse<dynamic>> requestGetDetailProject(
    @Path("project_id") int projectId,
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
      final payload = LoginRequest(
        inputUser: inputUser,
        password: password,
      );
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

      if (response.isSuccess) {
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

  //region user
  Future<Either<Failure, String>> requestCreateUser({
    required int idRole,
    required String name,
    required String username,
    required String phoneNumber,
    required String email,
    required String address,
    required String city,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final payload = CreateUserRequest(
        idRole: idRole,
        name: name,
        username: username,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        city: city,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final HttpResponse<dynamic> response =
          await api.requestCreateUser(payload);

      if (response.isSuccess) {
        final CreateUserResponse createUserResponse =
            CreateUserResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createUserResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeleteUser({
    required int userId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestDeleteUser(userId);

      if (response.isSuccess) {
        final DeleteUserResponse deleteUserResponse =
            DeleteUserResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteUserResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestUpdateUser({
    required int userId,
    required int idRole,
    required String name,
    required String username,
    required String phoneNumber,
    required String email,
    required String address,
    required String city,
  }) async {
    try {
      final payload = UpdateUserRequest(
        idRole: idRole,
        name: name,
        username: username,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        city: city,
      );
      final HttpResponse<dynamic> response = await api.requestUpdateUser(
        userId,
        payload,
      );

      if (response.isSuccess) {
        final UpdateCustomerResponse updateCustomerResponse =
            UpdateCustomerResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(updateCustomerResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, ListUserData>> requestGetAllUser({
    required int pageSize,
    required int currentPage,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllUser(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllUserResponse getAllUserResponse =
            GetAllUserResponse.fromJson(response.data);

        return Right<Failure, ListUserData>(getAllUserResponse.data);
      }
      return ErrorUtils<ListUserData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListUserData>().handleError(e);
    }
  }

  Future<Either<Failure, UserData>> requestUserDetail({
    required int userId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetUserDetail(userId);

      if (response.isSuccess) {
        final UserDetailResponse userDetailResponse =
            UserDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, UserData>(userDetailResponse.data);
      }

      return ErrorUtils<UserData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<UserData>().handleError(e);
    }
  }

  Future<Either<Failure, ListUserData>> searchUser({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchUser(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllUserResponse getAllUserResponse =
            GetAllUserResponse.fromJson(response.data);

        return Right<Failure, ListUserData>(getAllUserResponse.data);
      }
      return ErrorUtils<ListUserData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListUserData>().handleError(e);
    }
  }
  //endregion

  //region approval
  Future<Either<Failure, String>> requestUpdateApproval({
    required int approvalId,
    required int approvalStatus,
  }) async {
    try {
      UpdateApprovalRequest payload = UpdateApprovalRequest(
        approvalStatus: approvalStatus,
      );
      final HttpResponse<dynamic> response = await api.requestUpdateApproval(
        approvalId,
        payload,
      );

      if (response.isSuccess) {
        final UpdateApprovalResponse updateApprovalResponse =
            UpdateApprovalResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(updateApprovalResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, ListApprovalData>> requestGetAllApproval({
    required int pageSize,
    required int currentPage,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllApproval(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllApprovalResponse getAllApprovalResponse =
            GetAllApprovalResponse.fromJson(response.data);

        return Right<Failure, ListApprovalData>(getAllApprovalResponse.data);
      }
      return ErrorUtils<ListApprovalData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListApprovalData>().handleError(e);
    }
  }

  Future<Either<Failure, DetailApprovalData>> requestApprovalDetail({
    required int userId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetApprovalDetail(userId);

      if (response.isSuccess) {
        final ApprovalDetailResponse approvalDetailResponse =
            ApprovalDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, DetailApprovalData>(approvalDetailResponse.data);
      }

      return ErrorUtils<DetailApprovalData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<DetailApprovalData>().handleError(e);
    }
  }
  //endregion

  //region log
  Future<Either<Failure, ListLogData>> requestGetAllLog({
    required int pageSize,
    required int currentPage,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllLog(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllLogResponse getAllLog = GetAllLogResponse.fromJson(response.data);

        return Right<Failure, ListLogData>(getAllLog.data);
      }
      return ErrorUtils<ListLogData>().handleDomainError(response);
    } catch (e) {
      return ErrorUtils<ListLogData>().handleError(e);
    }
  }

  Future<Either<Failure, DetailLogData>> requestLogDetail({
    required int logId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetLogDetail(logId);

      if (response.isSuccess) {
        final DetailLogResponse detailLogResponse = DetailLogResponse.fromJson(
          response.data,
        );

        return Right<Failure, DetailLogData>(detailLogResponse.data);
      }

      return ErrorUtils<DetailLogData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<DetailLogData>().handleError(e);
    }
  }

  Future<Either<Failure, ListLogData>> searchLog({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchLog(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllLogResponse getAllLogResponse =
            GetAllLogResponse.fromJson(response.data);

        return Right<Failure, ListLogData>(getAllLogResponse.data);
      }
      return ErrorUtils<ListLogData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListLogData>().handleError(e);
    }
  }
  //endregion

  //region reminder
  Future<Either<Failure, ListReminderData>> requestGetAllReminder({
    required int pageSize,
    required int currentPage,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllReminder(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllReminderResponse getAllReminderResponse =
            GetAllReminderResponse.fromJson(response.data);

        return Right<Failure, ListReminderData>(getAllReminderResponse.data);
      }
      return ErrorUtils<ListReminderData>().handleDomainError(response);
    } catch (e) {
      return ErrorUtils<ListReminderData>().handleError(e);
    }
  }

  Future<Either<Failure, ListReminderData>> searchReminder({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchReminder(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllReminderResponse getAllReminderResponse =
            GetAllReminderResponse.fromJson(response.data);

        return Right<Failure, ListReminderData>(getAllReminderResponse.data);
      }
      return ErrorUtils<ListReminderData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListReminderData>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestCreateReminder({
    int? customerId,
    required String reminderDate,
    required String reminderTime,
    required String description,
    String? remindedNote,
    String? afterRemindedNote,
  }) async {
    try {
      final payload = CreateReminderRequest(
        customerId: customerId,
        reminderDate: reminderDate,
        reminderTime: reminderTime,
        description: description,
        remindedNote: remindedNote ?? "",
        afterRemindedNote: afterRemindedNote ?? "",
      );
      final HttpResponse<dynamic> response =
          await api.requestCreateReminder(payload);

      if (response.isSuccess) {
        final CreateReminderResponse createReminderResponse =
            CreateReminderResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(
          createReminderResponse.data.reminderId.toString(),
        );
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestUpdateReminder({
    required int reminderId,
    required String reminderDate,
    required String reminderTime,
    required String description,
    required String remindedNote,
    required String afterRemindedNote,
    required String phoneNumber,
  }) async {
    try {
      final payload = UpdateReminderRequest(
        reminderDate: reminderDate,
        reminderTime: reminderTime,
        description: description,
        remindedNote: remindedNote,
        afterRemindedNote: afterRemindedNote,
      );
      final HttpResponse<dynamic> response = await api.requestUpdateReminder(
        reminderId,
        payload,
      );

      if (response.isSuccess) {
        return const Right<Failure, bool>(true);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Sequence number error");
      return ErrorUtils<bool>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeleteReminder({
    required int reminderId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestDeleteReminder(reminderId);

      if (response.isSuccess) {
        final DeleteReminderResponse deleteReminderResponse =
            DeleteReminderResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteReminderResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, ReminderData>> requestDetailReminder({
    required int reminderId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetDetailReminder(reminderId);

      if (response.isSuccess) {
        final ReminderDetailResponse reminderDetailResponse =
            ReminderDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, ReminderData>(reminderDetailResponse.data);
      }

      return ErrorUtils<ReminderData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ReminderData>().handleError(e);
    }
  }
  //endregion

  //region customer
  Future<Either<Failure, ListCustomerData>> requestFilterCustomer(
      int currentPage,
      int pageSize,
      int customerType,
      int dataSource,
      int customerNeed,
      int sortBy) async {
    try {
      final HttpResponse<dynamic> response = await api.requestFilterCustomer(
        currentPage,
        pageSize,
        customerType,
        dataSource,
        customerNeed,
        sortBy,
      );

      if (response.isSuccess) {
        GetAllCustomerResponse getAllResponse =
            GetAllCustomerResponse.fromJson(response.data);

        return Right<Failure, ListCustomerData>(getAllResponse.data);
      }

      return ErrorUtils<ListCustomerData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListCustomerData>().handleError(e);
    }
  }

  Future<Either<Failure, ListCustomerData>> searchCustomer({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchCustomer(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllCustomerResponse getAllCustomerResponse =
            GetAllCustomerResponse.fromJson(response.data);

        return Right<Failure, ListCustomerData>(getAllCustomerResponse.data);
      }
      return ErrorUtils<ListCustomerData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListCustomerData>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestCreateCustomer({
    required String nama,
    required String customerNumber,
    required int customerType,
    required String customerNeed,
    required String email,
    required String companyName,
    required String phoneNumber,
    required String note,
    required String city,
  }) async {
    try {
      final payload = CreateCustomerRequest(
        customerName: nama,
        customerNumber: customerNumber,
        customerType: customerType,
        customerNeed: customerNeed,
        email: email,
        phoneNumber: phoneNumber,
        city: city,
        companyName: companyName,
        note: note,
        status: 0,
      );
      final HttpResponse<dynamic> response =
          await api.requestCreateCustomer(payload);

      if (response.isSuccess) {
        final CreateCustomerResponse createCustomerResponse =
            CreateCustomerResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createCustomerResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeleteCustomer({
    required int customerId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestDeleteCustomer(customerId);

      if (response.isSuccess) {
        final DeleteCustomerResponse deleteCustomerResponse =
            DeleteCustomerResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteCustomerResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestUpdateCustomer({
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

      if (response.isSuccess) {
        UpdateCustomerResponse updateCustomerResponse =
            UpdateCustomerResponse.fromJson(response.data);

        return Right<Failure, String>(updateCustomerResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Sequence number error");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, ListCustomerData>> getAllCustomer(
    int currentPage,
    int pageSize,
  ) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllCustomer(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllCustomerResponse getAllResponse =
            GetAllCustomerResponse.fromJson(response.data);

        return Right<Failure, ListCustomerData>(getAllResponse.data);
      }

      return ErrorUtils<ListCustomerData>().handleDomainError(response);
    } catch (e) {
      log("Sequence number error");
      return ErrorUtils<ListCustomerData>().handleError(e);
    }
  }

  Future<Either<Failure, CustomerData>> getDetailCustomer({
    required int customerId,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetDetailCustomer(
        customerId,
      );

      if (response.isSuccess) {
        GetDetailCustomerResponse getDetailCustomerResponse =
            GetDetailCustomerResponse.fromJson(response.data);

        return Right<Failure, CustomerData>(getDetailCustomerResponse.data);
      }

      return ErrorUtils<CustomerData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e ");
      return ErrorUtils<CustomerData>().handleError(e);
    }
  }

  Future<String> requestExportCustomerData() async {
    return 'http://www.africau.edu/images/default/sample.pdf';
  }
  //endregion

  //region unit
  Future<Either<Failure, ListUnitData>> getAllUnitByCustomer({
    required int customerId,
    required int currentPage,
    required int pageSize,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllUnitByCustomer(
        customerId,
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllUnitResponse getAllUnitResponse =
            GetAllUnitResponse.fromJson(response.data);

        return Right<Failure, ListUnitData>(getAllUnitResponse.data);
      }

      return ErrorUtils<ListUnitData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListUnitData>().handleError(e);
    }
  }

  Future<Either<Failure, ListUnitData>> searchUnit({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchUnit(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllUnitResponse getAllUnitResponse =
            GetAllUnitResponse.fromJson(response.data);

        return Right<Failure, ListUnitData>(getAllUnitResponse.data);
      }
      return ErrorUtils<ListUnitData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListUnitData>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestCreateUnit({
    required int customerId,
    required int projectId,
    required String unitName,
    required String unitLocation,
  }) async {
    try {
      final payload = CreateUnitRequest(
        projectId: projectId,
        unitName: unitName,
        customerId: customerId,
        unitLocation: unitLocation,
      );
      final HttpResponse<dynamic> response =
          await api.requestCreateUnit(payload);

      if (response.isSuccess) {
        final CreateUnitResponse createUnitResponse =
            CreateUnitResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createUnitResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestUpdateUnit({
    required int unitId,
    required int customerId,
    required int projectId,
    required String unitName,
    required String unitLocation,
  }) async {
    try {
      final payload = UpdateUnitRequest(
        customerId: customerId,
        projectId: projectId,
        unitName: unitName,
        unitLocation: unitLocation,
      );
      final HttpResponse<dynamic> response = await api.requestUpdateUnit(
        unitId,
        payload,
      );

      if (response.isSuccess) {
        return const Right<Failure, bool>(true);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<bool>().handleError(e);
    }
  }

  Future<Either<Failure, UnitData>> requestDetailUnit({
    required int unitId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetDetailUnit(unitId);

      if (response.isSuccess) {
        final UnitDetailResponse unitDetailResponse =
            UnitDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, UnitData>(unitDetailResponse.data);
      }

      return ErrorUtils<UnitData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<UnitData>().handleError(e);
    }
  }
  //endregion

  //region follow up
  Future<Either<Failure, ListFollowUpData>> requestGetAllFollowUp({
    required int currentPage,
    required int pageSize,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllFollowUp(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllFollowUpResponse getAllFollowUpResponse =
            GetAllFollowUpResponse.fromJson(response.data);

        return Right<Failure, ListFollowUpData>(getAllFollowUpResponse.data);
      }
      return ErrorUtils<ListFollowUpData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListFollowUpData>().handleError(e);
    }
  }

  Future<Either<Failure, FollowUpFrontData>> requestFollowUpDetail({
    required int followUpId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetFollowUpDetail(followUpId);

      if (response.isSuccess) {
        final FollowUpDetailResponse followUpDetailResponse =
            FollowUpDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, FollowUpFrontData>(followUpDetailResponse.data);
      }

      return ErrorUtils<FollowUpFrontData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<FollowUpFrontData>().handleError(e);
    }
  }

  Future<Either<Failure, ListFollowUpData>> searchFollowUp({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchFollowUp(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllFollowUpResponse getAllFollowUpResponse =
            GetAllFollowUpResponse.fromJson(response.data);

        return Right<Failure, ListFollowUpData>(getAllFollowUpResponse.data);
      }
      return ErrorUtils<ListFollowUpData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListFollowUpData>().handleError(e);
    }
  }

  Future<Either<Failure, List<HistoryFollowUpData>>> requestGetHistoryFollowUp({
    required String customerId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllHistoryFollowUp(
        customerId,
      );

      if (response.isSuccess) {
        GetHistoryFollowUpResponse getHistoryFollowUpResponse =
            GetHistoryFollowUpResponse.fromJson(response.data);

        return Right<Failure, List<HistoryFollowUpData>>(
            getHistoryFollowUpResponse.data.result);
      }
      return ErrorUtils<List<HistoryFollowUpData>>()
          .handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<List<HistoryFollowUpData>>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestCreateFollowUp({
    required int customerId,
    required String scheduleDate,
    required int followUpResult,
    required String note,
  }) async {
    try {
      final payload = CreateFollowUpRequest(
        customerId: customerId,
        followUpResult: followUpResult,
        scheduleDate: scheduleDate,
        note: note,
      );
      final HttpResponse<dynamic> response = await api.requestCreateFollowUp(
        payload,
      );

      if (response.isSuccess) {
        final CreateFollowUpResponse createFollowUpResponse =
            CreateFollowUpResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createFollowUpResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestUpdateFollowUp({
    required int followUpId,
    required int customerId,
    required String note,
    required int followUpResult,
    required String scheduleDate,
  }) async {
    try {
      final payload = UpdateFollowUpRequest(
        customerId: customerId,
        followUpResult: followUpResult,
        note: note,
        scheduleDate: scheduleDate,
      );

      final HttpResponse<dynamic> response = await api.requestUpdateFollowUp(
        followUpId,
        payload,
      );

      if (response.isSuccess) {
        return const Right<Failure, bool>(true);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<bool>().handleError(e);
    }
  }
  //endregion

  //region document
  Future<Either<Failure, String>> requestCreateDocument({
    required int fileType,
    required String filePath,
    required int customerId,
    required String note,
  }) async {
    try {
      final payload = CreateDocumentRequest(
        fileType: fileType,
        filePath: filePath,
        customerId: customerId,
        note: note,
      );
      final HttpResponse<dynamic> response =
          await api.requestCreateDocument(payload);

      if (response.isSuccess) {
        final CreateDocumentResponse createDocumentResponse =
            CreateDocumentResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createDocumentResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }
  //endregion

  //region maintenance
  Future<Either<Failure, ListMaintenanceData>> requestFilterMaintenance(
    int currentPage,
    int pageSize,
    int status,
    int sortBy,
  ) async {
    try {
      final HttpResponse<dynamic> response = await api.requestFilterMaintenance(
        currentPage,
        pageSize,
        status,
        sortBy,
      );

      if (response.isSuccess) {
        GetAllMaintenanceResponse getAllMaintenanceResponse =
            GetAllMaintenanceResponse.fromJson(response.data);

        return Right<Failure, ListMaintenanceData>(
          getAllMaintenanceResponse.data,
        );
      }

      return ErrorUtils<ListMaintenanceData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListMaintenanceData>().handleError(e);
    }
  }

  Future<Either<Failure, ListMaintenanceData>> searchMaintenance({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchMaintenance(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllMaintenanceResponse getAllMaintenanceResponse =
            GetAllMaintenanceResponse.fromJson(response.data);

        return Right<Failure, ListMaintenanceData>(
          getAllMaintenanceResponse.data,
        );
      }
      return ErrorUtils<ListMaintenanceData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListMaintenanceData>().handleError(e);
    }
  }

  Future<Either<Failure, ListMaintenanceData>> requestGetAllMaintenance(
    int currentPage,
    int pageSize,
  ) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllMaintenance(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllMaintenanceResponse getAllMaintenanceResponse =
            GetAllMaintenanceResponse.fromJson(response.data);

        return Right<Failure, ListMaintenanceData>(
            getAllMaintenanceResponse.data);
      }
      return ErrorUtils<ListMaintenanceData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListMaintenanceData>().handleError(e);
    }
  }

  Future<Either<Failure, MaintenanceData>> requestMaintenaceDetail({
    required int maintenanceId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetMaintenanceDetail(maintenanceId);

      if (response.isSuccess) {
        final MaintenanceDetailResponse maintenanceDetailResponse =
            MaintenanceDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, MaintenanceData>(maintenanceDetailResponse.data);
      }

      return ErrorUtils<MaintenanceData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<MaintenanceData>().handleError(e);
    }
  }

  //harusnya ga akan dipake
  Future<Either<Failure, String>> requesCreateMaintenance({
    required int unitId,
    required double latitude,
    required double longitude,
    required int maintenanceResult,
    required String scheduleDate,
    required String note,
  }) async {
    try {
      final payload = CreateMaintenanceRequest(
        unitId: unitId,
        latitude: latitude,
        longitude: longitude,
        maintenanceResult: maintenanceResult,
        scheduleDate: scheduleDate,
        note: note,
      );

      final HttpResponse<dynamic> response =
          await api.requestCreateMaintenance(payload);

      if (response.isSuccess) {
        final CreateMaintenanceResponse createMaintenanceResponse =
            CreateMaintenanceResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createMaintenanceResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, List<HistoryMaintenanceData>>>
      requestGetHistoryMaintenance(
    String unitId,
  ) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllHistoryMaintenance(
        unitId,
      );

      if (response.isSuccess) {
        GetHistoryMaintenanceResponse getHistoryMaintenanceResponse =
            GetHistoryMaintenanceResponse.fromJson(response.data);

        return Right<Failure, List<HistoryMaintenanceData>>(
            getHistoryMaintenanceResponse.data.result);
      }
      return ErrorUtils<List<HistoryMaintenanceData>>()
          .handleDomainError(response);
    } catch (e) {
      log("Sequence number error");
      return ErrorUtils<List<HistoryMaintenanceData>>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestUpdateMaintenace({
    required int maintenanceId,
    required int unitId,
    required int userId,
    required double longitude,
    required double latitude,
    required String note,
    required int maintenanceResult,
    required String scheduleDate,
  }) async {
    try {
      final payload = UpdateMaintenanceRequest(
        userId: userId,
        unitId: unitId,
        longitude: longitude,
        latitude: latitude,
        maintenanceResult: maintenanceResult,
        note: note,
        scheduleDate: scheduleDate,
      );

      final HttpResponse<dynamic> response = await api.requestUpdateMaintenance(
        maintenanceId,
        payload,
      );

      if (response.isSuccess) {
        return const Right<Failure, bool>(true);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<bool>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestChangeMaintenanceDate({
    required int maintenanceId,
    required String scheduleDate,
  }) async {
    try {
      final payload = ChangeMaintenanceDateRequest(
        scheduleDate: scheduleDate,
      );

      final HttpResponse<dynamic> response =
          await api.requestChangeeMaintenanceDate(
        maintenanceId,
        payload,
      );

      if (response.isSuccess) {
        final DeleteProjectResponse deleteProjectResponse =
            DeleteProjectResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteProjectResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeleteMaintenance({
    required int maintenanceId,
    required String reason,
  }) async {
    try {
      final payload = DeleteMaintenanceRequest(reason: reason);

      final HttpResponse<dynamic> response = await api.requestDeleteMaintenance(
        maintenanceId,
        payload,
      );

      if (response.isSuccess) {
        final DeleteMaintenanceResponse deleteMaintenanceResponse =
            DeleteMaintenanceResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteMaintenanceResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  //endregion

  //region projects
  Future<Either<Failure, ListProjectData>> getAllProjects({
    required int currentPage,
    required int pageSize,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestGetAllProjects(
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllProjectResponse getAllProjectResponse =
            GetAllProjectResponse.fromJson(response.data);

        return Right<Failure, ListProjectData>(getAllProjectResponse.data);
      }

      return ErrorUtils<ListProjectData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListProjectData>().handleError(e);
    }
  }

  Future<Either<Failure, ListProjectData>> requestGetAllProjectsByCustomerId({
    required int customerId,
    required int currentPage,
    required int pageSize,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetAllProjectsByCustomerId(
        customerId,
        currentPage,
        pageSize,
      );

      if (response.isSuccess) {
        GetAllProjectResponse getAllProjectResponse =
            GetAllProjectResponse.fromJson(response.data);

        return Right<Failure, ListProjectData>(getAllProjectResponse.data);
      }

      return ErrorUtils<ListProjectData>().handleDomainError(response);
    } catch (e) {
      log("Error: $e");
      return ErrorUtils<ListProjectData>().handleError(e);
    }
  }

  Future<Either<Failure, ListProjectData>> searchProject({
    required int pageSize,
    required int currentPage,
    required String inputUser,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.searchProject(
        currentPage,
        pageSize,
        inputUser,
      );

      if (response.isSuccess) {
        GetAllProjectResponse getAllProjectResponse =
            GetAllProjectResponse.fromJson(response.data);

        return Right<Failure, ListProjectData>(
          getAllProjectResponse.data,
        );
      }
      return ErrorUtils<ListProjectData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ListProjectData>().handleError(e);
    }
  }

  Future<Either<Failure, int>> requestCreateProject({
    required String projectName,
    required int projectNeed,
    required String address,
    required String city,
    required int customerId,
  }) async {
    try {
      final payload = CreateProjectRequest(
        projectName: projectName,
        projectNeed: projectNeed,
        address: address,
        city: city,
        customerId: customerId,
      );
      final HttpResponse<dynamic> response = await api.requestCreateProject(
        payload,
      );

      if (response.isSuccess) {
        final CreateProjectResponse createProjectResponse =
            CreateProjectResponse.fromJson(
          response.data,
        );

        return Right<Failure, int>(createProjectResponse.data.projectId);
      }

      return ErrorUtils<int>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<int>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeleteProject({
    required int projectId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestDeleteProject(projectId);

      if (response.isSuccess) {
        final DeleteProjectResponse deleteProjectResponse =
            DeleteProjectResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deleteProjectResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, bool>> requestUpdateProject({
    required String projectName,
    required int projectNeed,
    required String address,
    required String city,
    required int customerId,
    required int projectId,
  }) async {
    try {
      final payload = UpdateProjectRequest(
        customerId: customerId,
        projectName: projectName,
        projectNeed: projectNeed,
        address: address,
        city: city,
      );

      final HttpResponse<dynamic> response = await api.requestUpdateProject(
        projectId,
        payload,
      );

      if (response.isSuccess) {
        return const Right<Failure, bool>(true);
      }

      return ErrorUtils<bool>().handleDomainError(response);
    } catch (e) {
      log("Sequence number error");
      return ErrorUtils<bool>().handleError(e);
    }
  }

  Future<Either<Failure, ProjectData>> requestDetailProject({
    required int projectId,
  }) async {
    try {
      final HttpResponse<dynamic> response =
          await api.requestGetDetailProject(projectId);

      if (response.isSuccess) {
        final ProjectDetailResponse projectDetailResponse =
            ProjectDetailResponse.fromJson(
          response.data,
        );

        return Right<Failure, ProjectData>(projectDetailResponse.data);
      }

      return ErrorUtils<ProjectData>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<ProjectData>().handleError(e);
    }
  }
  //endregion

  //region pic project
  Future<Either<Failure, String>> requestCreatePIC({
    required List<PICProject> listPic,
    required int projectId,
  }) async {
    try {
      List<CreatePICProjectRequest> listPayloads = [];
      for (var pic in listPic) {
        listPayloads.add(
          CreatePICProjectRequest(
            projectId: projectId,
            picName: pic.picName,
            phoneNumber: pic.phoneNumber,
          ),
        );
      }

      final HttpResponse<dynamic> response = await api.requestCreatePICProject(
        listPayloads,
      );

      if (response.isSuccess) {
        final CreatePICProjectResponse createPICProjectResponse =
            CreatePICProjectResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(createPICProjectResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
  }

  Future<Either<Failure, String>> requestDeletePIC({
    required int picId,
  }) async {
    try {
      final HttpResponse<dynamic> response = await api.requestDeletePICProject(
        picId,
      );

      if (response.isSuccess) {
        final DeletePICProjectResponse deletePICProjectResponse =
            DeletePICProjectResponse.fromJson(
          response.data,
        );

        return Right<Failure, String>(deletePICProjectResponse.message);
      }

      return ErrorUtils<String>().handleDomainError(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<String>().handleError(e);
    }
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
