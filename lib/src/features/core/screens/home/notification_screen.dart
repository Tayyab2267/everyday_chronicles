import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../controllers/noti.dart';
import '../../controllers/notification_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Remove the requestPermission method, as it's not needed here.
  // Permission handling is done by awesome_notifications if you're using that package.

  @override
  void initState() {
    super.initState();

    // Initialize Awesome Notifications
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );

    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Notification Screen"),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Noti.showBigTextNotification(
                        title: "HAPPY",
                        body: "Your today's mood is 'HAPPY'",
                        fln: flutterLocalNotificationsPlugin);
                    print("Notification Button CLiked");
                  },
                  child: const Text("Title & body Notification"),
                ),
              ),
              NotificationButton(
                text: "Normal Notification",
                onPressed: () async {
                  await Noti.showNotification(
                      title: "Title of Notification",
                      body: "Body of Notification");
                },
              ),
              // Button Notification
              NotificationButton(
                text: "Button Notification",
                onPressed: () async {
                  await Noti.showNotification(
                    title: "Prayer Reminder",
                    body: "Have you offered Isha Prayer?",
                    payload: {
                      'yes_action_key': 'yes', // for Yes button
                      'no_action_key': 'no', // for No button
                      'later_action_key': 'later', // for Later button
                    },
                    actionButtons: [
                      NotificationActionButton(
                        key: 'yes',
                        label: 'Yes',
                        actionType: ActionType.Default,
                        color: Colors.green,
                      ),
                      NotificationActionButton(
                        key: 'no',
                        label: 'No',
                        actionType: ActionType.SilentAction,
                        color: Colors.red,
                      ),
                      NotificationActionButton(
                        key: 'later',
                        label: 'Later',
                        actionType: ActionType.SilentAction,
                        color: Colors.blueGrey,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
