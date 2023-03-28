import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  OneSignalService();

  Future<void> initOneSignal() async {
    await OneSignal.shared.setAppId("5819ec6f-0196-4e71-b042-49478c0ed81e");

    // We will update this once he logged in and goes to dashboard.
    //updateUserProfile(osUserID);

    // Store it into shared prefs, So that later we can use it.
    // OneSignPreferences.setOnesignalUserId(osUserID);

    _setOneSignalConfiguration();
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

      OSNotificationActionType? type = result.action?.type;
      switch (type) {
        case OSNotificationActionType.opened:
        case OSNotificationActionType.actionTaken:
      }
    });
  }

  Future<void> postNotification() async {
    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: "this is a test from OneSignal's Flutter SDK",
        heading: "Test Notification",
        androidLargeIcon: imgUrlString,
        bigPicture: imgUrlString,
        buttons: [
          OSActionButton(text: "test1", id: "id1"),
          OSActionButton(text: "test2", id: "id2")
        ]);
    var response = await OneSignal.shared.postNotification(notification);
  }

  Future<void> postScheduledNotification({
    required String description,
    required DateTime date,
  }) async {
    //   await OneSignal.shared.setRequiresUserPrivacyConsent(false);

    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    String dateStr = _convertDateTimeNotification(date);

    Map<String, dynamic> notification = {
      "app_id": "5819ec6f-0196-4e71-b042-49478c0ed81e",
      "included_segments": ["Subscribed Users"],
      "headings": {"en": "PT REJO JAYA SAKTI"},
      "data": {"foo": "bar"},
      "contents": {"en": "Mengingatkan anda untuk $description"},
      "send_after": "2023-03-29 00:32:00 GMT+0700",
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

  String _convertDateTimeNotification(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime.toUtc()) + " GMT";
  }
}
