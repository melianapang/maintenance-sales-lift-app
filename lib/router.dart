import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/unit_customer/edit_unit_customer_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/custom_base_url_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/approval/detail_approval_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/approval/list_approval_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/add_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/detail_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/edit_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/export_data_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/list_customer_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/customer/upload_po_view.dart';
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
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/form_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/maintenance/list_maintenance_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/manage_account/change_password_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/manage_account/edit_profile_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/map/map_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_project_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/detail_project_view.dart';
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
                firstName: '',
                lastName: '',
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
        return buildRoute(
          builder: (_) => const DetailApprovalView(),
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
        return buildRoute(
          builder: (_) => const UploadPOView(),
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
        return buildRoute(
          builder: (_) => const DetailFollowUpView(),
        );
      case Routes.detailHistoryFollowUp:
        return buildRoute(
          builder: (_) => const DetailHistoryFollowUpView(),
        );
      case Routes.formFollowUp:
        return buildRoute(
          builder: (_) => const FormFollowUpView(),
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
        return buildRoute(
          builder: (_) => const FormMaintenanceView(),
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
        return buildRoute(
          builder: (_) => const DetailReminderView(),
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
        return buildRoute(
          builder: (_) => const EditUserView(),
        );
      case Routes.detailUser:
        return buildRoute(
          builder: (_) => DetailUserView(
            profileData: ProfileData(
              username: "",
              firstName: "",
              lastName: "",
              address: "",
              city: "",
              phoneNumber: "",
              email: "",
              role: Role.Admin,
            ),
          ),
        );
      case Routes.setPasswordUser:
        return buildRoute(
          builder: (_) => const SetPasswordUserView(),
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
        return buildRoute(
          builder: (_) => const AddPicProjectView(),
        );
      case Routes.editProject:
        return buildRoute(
          builder: (_) => const EditProjectView(),
        );
      case Routes.detailProject:
        return buildRoute(
          builder: (_) => DetailProjectView(
            profileData: ProfileData(
              username: "",
              firstName: "",
              lastName: "",
              address: "",
              city: "",
              phoneNumber: "",
              email: "",
              role: Role.Admin,
            ),
          ),
        );
      case Routes.listUnit:
        return buildRoute(
          builder: (_) => const ListUnitCustomerView(),
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
        return buildRoute(
          builder: (_) => const AddUnitCustomerView(),
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
