import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/failure/failure_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/utils/error_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/reminders/open_notification_reminder_view.dart';

class OneSignalService {
  OneSignalService({
    required NavigationService navigationService,
  }) : _navigationService = navigationService;

  final NavigationService _navigationService;

  Future<void> initOneSignal() async {
    await OneSignal.shared.setAppId("5819ec6f-0196-4e71-b042-49478c0ed81e");

    // We will update this once he logged in and goes to dashboard.
    //updateUserProfile(osUserID);

    // Store it into shared prefs, So that later we can use it.
    // OneSignPreferences.setOnesignalUserId(osUserID);

    await _setOneSignalConfiguration();
    _initOneSignalListener();
  }

  Future<void> _setOneSignalConfiguration() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.disablePush(false);
    await OneSignal.shared.setRequiresUserPrivacyConsent(false);
  }

  void _initOneSignalListener() {
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared
        .promptUserForPushNotificationPermission(
          fallbackToSettings: true,
        )
        .then(
          (accepted) => print("Accepted OneSignal permission: $accepted"),
        );

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      // event.complete(event.notification);
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      // event.complete(null);
      event.complete(event.notification);
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");

      String onesignalUserId = changes.to.userId ?? "";
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    _handleNotificationActions();
  }

  void _handleNotificationActions() {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      print("ID BUTTON ACTIONS: ${result.action?.actionId}");

      Map<String, dynamic>? data = result.notification.additionalData;
      switch (result.action?.type) {
        case OSNotificationActionType.opened:
          _openNotificationHandler(data);
          break;

        case OSNotificationActionType.actionTaken:
          switch (result.action?.actionId) {
            case "positiveButton":
              _openNotificationHandler(data);
              break;

            case "negativeButton":
              _setSnoozeReminder(data);
              break;
          }
      }
    });
  }

  Future<Either<Failure, bool>> postNotification({
    required String description,
    required String time,
    required DateTime date,
    required String note,
    required String reminderId,
  }) async {
    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) {
      return ErrorUtils<bool>().handleError("User ID tidak ada.");
    }

    var playerId = deviceState.userId!;

    var imgUrlString = "assets/images/logo_pt_rejo.png";
    // "https://media1.popsugar-assets.com/files/thumbor/0ebv7kCHr0T-_O3RfQuBoYmUg1k/475x60:1974x1559/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg";

    try {
      var notification = OSCreateNotification(
        playerIds: [playerId],
        heading: "PT REJO JAYA SAKTI",
        content: "Mengingatkan anda untuk $description",
        androidSmallIcon: imgUrlString,
        additionalData: {
          "date": DateTimeUtils.convertDateToString(
            date: date,
            formatter: DateFormat('dd MMM yyyy'),
          ),
          "time": time,
          "note": note,
          "description": description,
          "reminderId": reminderId,
        },
        sendAfter: date.toUtc(),
        buttons: [
          OSActionButton(id: "positiveButton", text: "Ya, buka Catatan."),
          OSActionButton(id: "negativeButton", text: "Lewatkan")
        ],
      );

      await OneSignal.shared.postNotification(notification);

      return const Right<Failure, bool>(true);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ErrorUtils<bool>().handleError(e);
    }
  }

  Future<void> postScheduledNotification({
    required String description,
    required String date,
  }) async {
    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    Map<String, dynamic> notification = {
      "app_id": "5819ec6f-0196-4e71-b042-49478c0ed81e",
      "included_segments": ["Subscribed Users"],
      "headings": {"en": "PT REJO JAYA SAKTI"},
      "data": {"foo": "bar"},
      "contents": {"en": "Mengingatkan anda untuk $description"},
      // "send_after": "2023-03-29 00:32:00 GMT+0700",
      "send_after": date,
      "buttons": [
        {"id": "1", "text": "button1"},
        {"id": "2", "text": "button2"}
      ]
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic N2VlN2M3ZmUtZGNlYi00NTZjLTg4MTEtNGUxNDk0ODJhMTkw',
    };

    try {
      final response = await http.post(
        Uri.parse("https://onesignal.com/api/v1/notifications"),
        headers: headers,
        body: jsonEncode(notification),
      );

      print("responsee: ${response.statusCode}");
    } catch (e) {
      print("error: ${e.toString()}");
    }
  }

  void _openNotificationHandler(Map<String, dynamic>? data) {
    _navigationService.popAllAndNavigateTo(
      Routes.openNotificationReminder,
      arguments: OpenNotificationReminderViewParam(
        date: data?["date"],
        time: data?["time"],
        description: data?["description"],
        note: data?["note"],
        reminderId: data?["reminderId"],
      ),
    );
  }

  void _setSnoozeReminder(Map<String, dynamic>? data) async {
    final DateTime snoozeUntil =
        DateTime.parse("${data?["date"]} ${data?["time"]}").add(
      Duration(
        days: 14,
      ),
    );

    await postNotification(
      description: data?["description"],
      time: data?["time"],
      date: snoozeUntil,
      note: data?["note"],
      reminderId: data?["reminderId"],
    );
  }
}
