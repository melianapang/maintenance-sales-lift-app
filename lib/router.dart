import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/custom_base_url_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/approval/detail_approval_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/approval/list_approval_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/add_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/detail_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/edit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/export_data_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/list_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/upload_document_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/non_project_customer/add_non_project_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/non_project_customer/detail_non_project_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/non_project_customer/edit_non_project_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/non_project_customer/list_non_project_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/detail_history_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/form_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/follow_up/list_follow_up_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/home_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/image_detail_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/log/detail_log_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/log/list_log_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/login_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_history_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/detail_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/export_data_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_change_maintenance_date_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_delete_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/list_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/manage_account/change_password_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/manage_account/edit_profile_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/map/map_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/master_customer/customer_need/list_customer_need_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/master_customer/customer_type/list_customer_type_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/master_customer/master_customer_menu_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/detail_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/document_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/edit_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/list_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/after_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/detail_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/form_set_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/list_reminders_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/open_notification_reminder_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/splash_screen_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/add_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/detail_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/edit_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/unit_customer/list_unit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/add_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/detail_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/edit_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/list_user_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/users/set_password_user_view.dart';

final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    MaterialPageRoute<T>? buildRoute<T>({
      required Widget Function(BuildContext) builder,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<T>(
        settings: settings,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case Routes.splashScreen:
        return buildRoute(
          builder: (_) => const SplashScreenView(),
        );
      case Routes.login:
        return buildRoute(
          builder: (_) => const LoginView(),
        );
      case Routes.home:
        final ProfileData param = settings.arguments is ProfileData
            ? settings.arguments as ProfileData
            : ProfileData(
                username: '',
                name: '',
                phoneNumber: '',
                email: '',
                address: '',
                city: '',
                role: Role.Admin,
              );
        return buildRoute(
          builder: (_) => const HomeView(),
        );
      case Routes.afterSetReminder:
        return buildRoute(
          builder: (_) => const AfterSetReminderView(),
        );
      case Routes.openNotificationReminder:
        final OpenNotificationReminderViewParam param =
            settings.arguments is OpenNotificationReminderViewParam
                ? settings.arguments as OpenNotificationReminderViewParam
                : OpenNotificationReminderViewParam();
        return buildRoute(
          builder: (_) => OpenNotificationReminderView(
            param: param,
          ),
        );
      case Routes.editProfile:
        final EditProfileViewParam param =
            settings.arguments is EditProfileViewParam
                ? settings.arguments as EditProfileViewParam
                : EditProfileViewParam();
        return buildRoute(
          builder: (_) => EditProfileView(param: param),
        );
      case Routes.changePassword:
        return buildRoute(
          builder: (_) => const ChangePasswordView(),
        );
      case Routes.listApproval:
        return buildRoute(
          builder: (_) => const ListApprovalView(),
        );
      case Routes.detailApproval:
        final DetailApprovalViewParam param =
            settings.arguments is DetailApprovalViewParam
                ? settings.arguments as DetailApprovalViewParam
                : DetailApprovalViewParam();
        return buildRoute(
          builder: (_) => DetailApprovalView(
            param: param,
          ),
        );
      case Routes.listCustomer:
        return buildRoute(
          builder: (_) => const ListCustomerView(),
        );
      case Routes.detailCustomer:
        final DetailCustomerViewParam param =
            settings.arguments is DetailCustomerViewParam
                ? settings.arguments as DetailCustomerViewParam
                : DetailCustomerViewParam();
        return buildRoute(
          builder: (_) => DetailCustomerView(
            param: param,
          ),
        );
      case Routes.addCustomer:
        return buildRoute(
          builder: (_) => const AddCustomerView(),
        );
      case Routes.editCustomer:
        final EditCustomerViewParam param =
            settings.arguments is EditCustomerViewParam
                ? settings.arguments as EditCustomerViewParam
                : EditCustomerViewParam();
        return buildRoute(
          builder: (_) => EditCustomerView(
            param: param,
          ),
        );
      case Routes.exportCustomer:
        return buildRoute(
          builder: (_) => const ExportDataCustomerView(),
        );
      case Routes.uploadPO:
        final UploadDocumentViewParam param =
            settings.arguments is UploadDocumentViewParam
                ? settings.arguments as UploadDocumentViewParam
                : UploadDocumentViewParam();
        return buildRoute(
          builder: (_) => UploadDocumentView(
            param: param,
          ),
        );
      case Routes.listLog:
        return buildRoute(
          builder: (_) => const ListLogView(),
        );
      case Routes.detailLog:
        final DetailLogViewParam param =
            settings.arguments is DetailLogViewParam
                ? settings.arguments as DetailLogViewParam
                : DetailLogViewParam();
        return buildRoute(
          builder: (_) => DetailLogView(
            param: param,
          ),
        );
      case Routes.listFollowUp:
        return buildRoute(
          builder: (_) => const ListFollowUpView(),
        );
      case Routes.detailFollowUp:
        final DetailFollowUpViewParam param =
            settings.arguments is DetailFollowUpViewParam
                ? settings.arguments as DetailFollowUpViewParam
                : DetailFollowUpViewParam();
        return buildRoute(
          builder: (_) => DetailFollowUpView(
            param: param,
          ),
        );
      case Routes.detailHistoryFollowUp:
        final DetailHistoryFollowUpViewParam param =
            settings.arguments is DetailHistoryFollowUpViewParam
                ? settings.arguments as DetailHistoryFollowUpViewParam
                : DetailHistoryFollowUpViewParam();
        return buildRoute(
          builder: (_) => DetailHistoryFollowUpView(
            param: param,
          ),
        );
      case Routes.formFollowUp:
        final FormFollowUpViewParam param =
            settings.arguments is FormFollowUpViewParam
                ? settings.arguments as FormFollowUpViewParam
                : FormFollowUpViewParam();
        return buildRoute(
          builder: (_) => FormFollowUpView(
            param: param,
          ),
        );
      case Routes.listMaintenance:
        return buildRoute(
          builder: (_) => const ListMaintenanceView(),
        );
      case Routes.detailMaintenance:
        final DetailMaintenanceViewParam param =
            settings.arguments is DetailMaintenanceViewParam
                ? settings.arguments as DetailMaintenanceViewParam
                : DetailMaintenanceViewParam();
        return buildRoute(
          builder: (_) => DetailMaintenanceView(
            param: param,
          ),
        );
      case Routes.detailHistoryMaintenance:
        final DetailHistoryMaintenanceViewParam param =
            settings.arguments is DetailHistoryMaintenanceViewParam
                ? settings.arguments as DetailHistoryMaintenanceViewParam
                : DetailHistoryMaintenanceViewParam();
        return buildRoute(
          builder: (_) => DetailHistoryMaintenanceView(
            param: param,
          ),
        );
      case Routes.exportMaintenance:
        return buildRoute(
          builder: (_) => const ExportDataMaintenanceView(),
        );
      case Routes.formMaintenance:
        final FormMaintenanceViewParam param =
            settings.arguments is FormMaintenanceViewParam
                ? settings.arguments as FormMaintenanceViewParam
                : FormMaintenanceViewParam();
        return buildRoute(
          builder: (_) => FormMaintenanceView(
            param: param,
          ),
        );
      case Routes.formDeleteMaintenance:
        final FormDeleteMaintenanceViewParam param =
            settings.arguments is FormDeleteMaintenanceViewParam
                ? settings.arguments as FormDeleteMaintenanceViewParam
                : FormDeleteMaintenanceViewParam();
        return buildRoute(
          builder: (_) => FormDeleteMaintenanceView(
            param: param,
          ),
        );
      case Routes.formChangeMaintenanceDate:
        final FormChangeMaintenanceDateViewParam param =
            settings.arguments is FormChangeMaintenanceDateViewParam
                ? settings.arguments as FormChangeMaintenanceDateViewParam
                : FormChangeMaintenanceDateViewParam();
        return buildRoute(
          builder: (_) => FormChangeMaintenanceDateView(
            param: param,
          ),
        );
      case Routes.listReminder:
        return buildRoute(
          builder: (_) => const ListRemindersView(),
        );
      case Routes.formSetReminder:
        final FormSetReminderViewParam param =
            settings.arguments is FormSetReminderViewParam
                ? settings.arguments as FormSetReminderViewParam
                : FormSetReminderViewParam(
                    source: FormSetReminderSource.ListReminderPage,
                  );
        return buildRoute(
          builder: (_) => FormSetReminderView(
            param: param,
          ),
        );
      case Routes.detailReminder:
        final DetailReminderViewParam param =
            settings.arguments is DetailReminderViewParam
                ? settings.arguments as DetailReminderViewParam
                : DetailReminderViewParam();
        return buildRoute(
          builder: (_) => DetailReminderView(
            param: param,
          ),
        );
      case Routes.map:
        final MapViewParam param = settings.arguments is MapViewParam
            ? settings.arguments as MapViewParam
            : MapViewParam();
        return buildRoute(
          builder: (_) => MapView(
            param: param,
          ),
        );
      case Routes.listUser:
        return buildRoute(
          builder: (_) => const ListUserView(),
        );
      case Routes.addUser:
        return buildRoute(
          builder: (_) => const AddUserView(),
        );
      case Routes.editUser:
        final EditUserViewParam param = settings.arguments is EditUserViewParam
            ? settings.arguments as EditUserViewParam
            : EditUserViewParam();
        return buildRoute(
          builder: (_) => EditUserView(
            param: param,
          ),
        );
      case Routes.detailUser:
        final DetailUserViewParam param =
            settings.arguments is DetailUserViewParam
                ? settings.arguments as DetailUserViewParam
                : DetailUserViewParam();
        return buildRoute(
          builder: (_) => DetailUserView(
            param: param,
          ),
        );
      case Routes.setPasswordUser:
        final SetPasswordUserViewParam param =
            settings.arguments is SetPasswordUserViewParam
                ? settings.arguments as SetPasswordUserViewParam
                : SetPasswordUserViewParam();
        return buildRoute(
          builder: (_) => SetPasswordUserView(
            param: param,
          ),
        );
      case Routes.listProjects:
        return buildRoute(
          builder: (_) => const ListProjectView(),
        );
      case Routes.addProject:
        return buildRoute(
          builder: (_) => const AddProjectView(),
        );
      case Routes.addPicProject:
        final AddPicProjectViewParam param =
            settings.arguments is AddPicProjectViewParam
                ? settings.arguments as AddPicProjectViewParam
                : AddPicProjectViewParam();
        return buildRoute(
          builder: (_) => AddPicProjectView(
            param: param,
          ),
        );
      case Routes.editProject:
        final EditProjectViewParam param =
            settings.arguments is EditProjectViewParam
                ? settings.arguments as EditProjectViewParam
                : EditProjectViewParam();
        return buildRoute(
          builder: (_) => EditProjectView(
            param: param,
          ),
        );
      case Routes.detailProject:
        final DetailProjectViewParam param =
            settings.arguments is DetailProjectViewParam
                ? settings.arguments as DetailProjectViewParam
                : DetailProjectViewParam();
        return buildRoute(
          builder: (_) => DetailProjectView(
            param: param,
          ),
        );
      case Routes.documentProject:
        final DocumentProjectViewwParam param =
            settings.arguments is DocumentProjectViewwParam
                ? settings.arguments as DocumentProjectViewwParam
                : DocumentProjectViewwParam();
        return buildRoute(
          builder: (_) => DocumentProjectView(
            param: param,
          ),
        );
      case Routes.listUnit:
        final ListUnitCustomerViewParam param =
            settings.arguments is ListUnitCustomerViewParam
                ? settings.arguments as ListUnitCustomerViewParam
                : ListUnitCustomerViewParam();
        return buildRoute(
          builder: (_) => ListUnitCustomerView(
            param: param,
          ),
        );
      case Routes.detailUnit:
        final DetailUnitCustomerViewParam param =
            settings.arguments is DetailUnitCustomerViewParam
                ? settings.arguments as DetailUnitCustomerViewParam
                : DetailUnitCustomerViewParam();
        return buildRoute(
          builder: (_) => DetailUnitCustomerView(
            param: param,
          ),
        );
      case Routes.addUnit:
        final AddUnitCustomerViewParam param =
            settings.arguments is AddUnitCustomerViewParam
                ? settings.arguments as AddUnitCustomerViewParam
                : AddUnitCustomerViewParam();
        return buildRoute(
          builder: (_) => AddUnitCustomerView(
            param: param,
          ),
        );
      case Routes.editUnit:
        final EditUnitCustomerViewParam param =
            settings.arguments is EditUnitCustomerViewParam
                ? settings.arguments as EditUnitCustomerViewParam
                : EditUnitCustomerViewParam();
        return buildRoute(
          builder: (_) => EditUnitCustomerView(
            param: param,
          ),
        );
      case Routes.listNonProjectCustomer:
        return buildRoute(
          builder: (_) => const ListNonProjectCustomerView(),
        );
      case Routes.detailNonProjectCustomer:
        final DetailNonProjectCustomerViewParam param =
            settings.arguments is DetailNonProjectCustomerViewParam
                ? settings.arguments as DetailNonProjectCustomerViewParam
                : DetailNonProjectCustomerViewParam();
        return buildRoute(
          builder: (_) => DetailNonProjectCustomerView(
            param: param,
          ),
        );
      case Routes.addNonProjectCustomer:
        return buildRoute(
          builder: (_) => const AddNonProjectCustomerView(),
        );
      case Routes.editNonProjectCustomer:
        final EditNonProjectCustomerViewParam param =
            settings.arguments is EditNonProjectCustomerViewParam
                ? settings.arguments as EditNonProjectCustomerViewParam
                : EditNonProjectCustomerViewParam();
        return buildRoute(
          builder: (_) => EditNonProjectCustomerView(
            param: param,
          ),
        );
      //Master Customer
      case Routes.masterCustomerMenu:
        return buildRoute(
          builder: (_) => const MasterCustomerMenuView(),
        );
      case Routes.listCustomerNeed:
        return buildRoute(
          builder: (_) => const ListCustomerNeedView(),
        );
      case Routes.listCustomerType:
        return buildRoute(
          builder: (_) => const ListCustomerTypeView(),
        );

      // Gallery
      case Routes.imageDetail:
        final ImageDetailViewParam param =
            settings.arguments is ImageDetailViewParam
                ? settings.arguments as ImageDetailViewParam
                : ImageDetailViewParam();
        return buildRoute(
          builder: (_) => ImageDetailView(param: param),
        );

      // Misc
      case Routes.customBaseURL:
        return buildRoute(
          builder: (_) => const CustomBaseURLView(),
        );

      default:
        return null;
    }
  }
}
