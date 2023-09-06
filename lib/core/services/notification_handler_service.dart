import 'dart:convert';

import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/notification/local_push_notif_payload.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/local_notification_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/open_notification_reminder_view.dart';

class NotificationHandlerService {
  NotificationHandlerService({
    required NavigationService navigationService,
    // required DeepLinkService deepLinkService,
    required AuthenticationService authenticationService,
  })  : _navigationService = navigationService,
        // _deepLinkService = deepLinkService,
        _authenticationService = authenticationService;

  final NavigationService _navigationService;
  // final DeepLinkService _deepLinkService;
  final AuthenticationService _authenticationService;

  Map<String, dynamic> extractDataFromFCM(Map<String, dynamic> message) {
    // if (Platform.isIOS) return Map<String, dynamic>.from(message);
    return Map<String, dynamic>.from(message['data'] ?? {});
  }

  Map<String, dynamic> extractPayloadFromData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return {};
    }

    return json.decode((data['payload'] ?? '{}'));
  }

  // LocalPushNotifPayload? extractNotificationFromMessage(
  //   Map<String, dynamic> message,
  // ) {
  //   // if (Platform.isIOS) {
  //   //   Map<String, dynamic>? aps = Map<String, dynamic>.from(message['aps']);
  //   //   if (aps.isEmpty || aps['alert'] == null) return null;

  //   //   String title = aps['alert']?['title'];
  //   //   String body = aps['alert']['title'];
  //   //   if (title.isEmpty || body.isEmpty) return null;

  //   //   return LocalPushNotifPayload(title, body);
  //   // }

  //   Map<String, dynamic>? data = Map<String, dynamic>.from(message['data']);

  //   if (data.containsKey('title') && data.containsKey('title')) {
  //     return LocalPushNotifPayload(data['title'], data['body']);
  //   }

  //   return null;
  // }

  Future<dynamic> handleOnTapLocalNotification(String? jsonPayload) async {
    final Map<String, dynamic> payload = json.decode(jsonPayload!);
    handleOnTapNotification(payload);
  }

  void handleOnTapNotification(Map<String, dynamic> data) {
    final type = NotifMessageTypes.notifMessageTypes[data['type']];

    final bool isNotificationFromQiscus = data.containsKey('chat_room_id');
    if (isNotificationFromQiscus) {
      final String? roomId = data['chat_room_id'];
      if (roomId == null) {
        return;
      }

      return;
    }

    switch (type) {
      case NotifMessageType.Deeplink:
        final Map<String, dynamic> payload =
            json.decode(data['payload'] ?? '{}');
        final String deeplinkString =
            data['deeplink'] ?? payload['deeplink'] ?? '';

        final Uri deepLink = Uri.parse(deeplinkString);
        // _dynamicLinkService.handleDeepLink(deepLink);
        break;
      case NotifMessageType.Maintenance:
      case NotifMessageType.FollowUp:
        final argument = LocalPushNotifPayload.fromJson(data);
        _navigationService.navigateTo(
          Routes.openNotificationReminder,
          arguments: OpenNotificationReminderViewParam(
            date: argument.date,
            time: argument.time,
            description: argument.description,
            note: argument.note,
            reminderId: argument.reminderId,
          ),
        );
        break;
      default:
        _navigationService.navigateTo(Routes.home);
        break;
    }
  }
}

enum NotifMessageType { Maintenance, FollowUp, Deeplink }

extension NotifMessageTypeExt on NotifMessageType {
  String get asString {
    switch (this) {
      case NotifMessageType.Maintenance:
        return "maintenance";
      case NotifMessageType.FollowUp:
        return "followup";
      case NotifMessageType.Deeplink:
        return "deeplink";
    }
  }
}

class NotifMessageTypes {
  static const notifMessageTypes = {
    'deeplink': NotifMessageType.Deeplink,
    'maintenance': NotifMessageType.Maintenance,
    'followup': NotifMessageType.FollowUp,
  };
}
