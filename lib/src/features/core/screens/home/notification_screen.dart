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

  Future<void> requestPermissions() async {
    bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    print("Permission Allowed or Not: $result");
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
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
              NotificationButton(
                text: "Button Notification",
                onPressed: () async {
                  await Noti.showNotification(
                    title: "Title of Notification",
                    body: "Body of Notification",
                    payload: {},
                    actionButtons: [
                      NotificationActionButton(
                        key: 'Check',
                        label: 'check it out',
                        actionType: ActionType.SilentAction,
                        color: Colors.green,
                      )
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
