import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class Noti {
  static Future initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic Notification',
          channelDescription: 'notification channel for description',
          defaultColor: Colors.green,
          ledColor: Colors.red,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> prayerMethod(String prayerName) async {
    print("Inside pryaer method");
    List<dynamic> prayerData = [];
    DateTime now = DateTime.now();
    String formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    prayerData.add(formattedTime);
    prayerData.add(prayerName);

    print("-----> prayerData prayerMethod Class: $prayerData");

    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
    String? requiredPrayerList = await SQLHelper.getPrayerListByDate(presentDate);
    print("-----> prayerList from Database: $requiredPrayerList");

    if (requiredPrayerList != null) {
      List<dynamic> unpackedPrayerList =
      jsonDecode(requiredPrayerList);
      prayerData.addAll(unpackedPrayerList);
      print("-----> add database weather list to prayerData: $prayerData");
    } else {
      print("-----> No prayer list found in the database or it's empty.");
    }

    SQLHelper.updateItemPrayerByDate(presentDate, jsonEncode(prayerData));
    print("-----> End Function");
  }

  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onActionReceivedMethod');

    final Map<String, dynamic> mapData = receivedNotification.toMap();
    final String? buttonKeyPressed = mapData['buttonKeyPressed'];
    print("ButtonKeyPressed: $buttonKeyPressed");
    ///
    if (buttonKeyPressed != null) {
      switch (buttonKeyPressed) {
        case 'yes_fajar':
          {
            print('User has offered Fajar Prayer');
            prayerMethod("Fajar");
          }
          break;
        case 'no_fajar':
          {
            print('User did not offer fajar prayer');
          }
        case 'yes_zuhar':
          {
            print('User has offered Zuhar Prayer');
            prayerMethod("Zuhar");
          }
          break;
        case 'no_zuhar':
          {
            print('User did not offer Zuhar prayer');
          }
          break;
        case 'yes_asar':
          {
            print('User has offered Asar Prayer');
            prayerMethod("Asar");
          }
          break;
        case 'no_asar':
          {
            print('User did not offer Asar prayer');
          }
          break;
        case 'yes_maghrib':
          {
            print('User has offered Maghrib Prayer');
            prayerMethod("Maghrib");
          }
          break;
        case 'no_maghrib':
          {
            print('User did not offer Maghrib prayer');
          }
          break;
        case 'yes_isha':
          {
            print('User has offered Isha Prayer');
            prayerMethod("Isha");
          }
          break;
        case 'no_isha':
          {
            print('User did not offer Isha prayer');
          }
          break;
        default:
          {
            print("default nothing clicked...");
          }
          break;
      }
    }

    // if (payload["navigate"] == "true") {}
  }



  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      enableVibration: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(id, title, body, not);
  }
}
