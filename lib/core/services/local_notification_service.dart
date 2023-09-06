import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rejo_jaya_sakti_apps/core/models/notification/local_push_notif_payload.dart';
import 'package:rejo_jaya_sakti_apps/core/services/notification_handler_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void _backgroundHandler(NotificationResponse response) {
  print(response.payload);
}

class LocalNotificationService {
  LocalNotificationService(
    Future<dynamic> Function(String? payload)? onTapNotif,
  ) : _onTapNotif = onTapNotif;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  final DarwinInitializationSettings _initializationSettingsIOS =
      const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );

  final Map<String, String> defaultChannelAndroid = <String, String>{
    'id': 'default',
    'name': 'Notifications',
    'description': '',
  };

  final Future<dynamic> Function(String? payload)? _onTapNotif;

  int notifId = 0;

  Future<bool?> initialize() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
    );

    final bool? initializationResult = await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onTapNotif?.call(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: _backgroundHandler,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));

    // if (AppConstant.platform == AppConstant.iOSPlatform) {
    //   return await _plugin
    //       .resolvePlatformSpecificImplementation<
    //           IOSFlutterLocalNotificationsPlugin>()
    //       ?.requestPermissions(
    //         alert: true,
    //         badge: true,
    //         sound: true,
    //       );
    // }

    return initializationResult;
  }

  Future<void> createScheduledNotification({
    required String description,
    required DateTime date,
    required DateTime time,
    required NotifMessageType type,
    required LocalPushNotifPayload payload,
  }) async {
    Map<String, dynamic> payloads = payload.toJson();
    payloads.addAll({
      "type": type.asString,
    });

    await _plugin.zonedSchedule(
      0,
      'PT REJO JAYA SAKTI',
      description,
      tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second,
        time.millisecond,
        time.microsecond,
      ),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Default',
          'Default',
          icon: "app_icon",
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: false,
        ),
      ),
      payload: json.encode(payloads),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> clearNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> showSimpleNotif({
    required String title,
    required String body,
    required String payload,
    bool repeatId = false,
  }) async {
    final NotificationDetails notifDefails = NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannelAndroid['id']!,
        defaultChannelAndroid['name']!,
        channelDescription: defaultChannelAndroid['description'],
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(),
    );

    _plugin.show(
      notifId,
      title,
      body,
      notifDefails,
      payload: payload,
    );

    if (!repeatId) notifId += 1;
  }
}

// class LocalPushNotifPayload {
//   const LocalPushNotifPayload(
//     this.title,
//     this.body,
//   );
//   final String title;
//   final String body;
// }
