import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';

// void callbackDispatcher() {
//   print(" ------> callbackDispatcher() function has been run");
//   Workmanager().executeTask((taskName, inputData) async {
//     // here I used switch statement because we have multiple tasks to run in background.
//     String emailBox = inputData?['string'];
//     print(" ------> Before Switch statement");
//     switch (taskName) {
//       case 'task_one':
//         {
//           //task_one_create_dummy_day_data
//           print("\n\n\t ........................................\n\n");
//           print("\n\n\t ............. Task no 01 ................\n\n");
//           print("\n\n\t ............. $emailBox ................\n\n");
//           print("\n\n\t ........................................\n\n");
//
//           // create dummy list for Hive Day Data
//           // List<dynamic> dummyList = [
//           //   Icons.sentiment_satisfied,
//           //   "Title Of Day",
//           //   "Subtitle which is dummy text of the day. it will change later when a user will complete its day."
//           // ];
//
//           //open existing user HiveBox
//           // var currentUserHiveBox = await Hive.openBox(emailBox);
//           // print("Box  created");
//           // final myBox = Hive.box(emailBox);
//           // print("Box opened");
//           // myBox.put(getCurrentDate, dummyList);
//           // print("Box put");
//           // print(myBox.get(getCurrentDate));
//           // print("Box get");
//         }
//         break;
//
//       default:
//     }
//     return Future.value(true);
//   });
// }

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day} ${now.month} ${now.year} ${now.hour}:${now.minute}';
    return formattedDate;
  }

  // initWorkmanager() async {
  //   print(" ------> Inside init Work Manager");
  //   try {
  //     await Workmanager().initialize(
  //       callbackDispatcher,
  //       // isInDebugMode true means it will shows Notification on mobile
  //       // to confirm that functions work properly
  //       isInDebugMode: true,
  //     );
  //   } catch (e) {
  //     print(" ---------> Exception Occurs: ${e.toString()}");
  //   }
  //   print(" ------> After WorkManager true debug mode");
  // }

  createDummyDayDataService() async {
    //initWorkmanager();
    print("\t ---------> createDummyDayDataService() Started");
    // await Workmanager().registerOneOffTask(
    //   'task_one_unique_name',
    //   'task_one',
    //   initialDelay: const Duration(seconds: 10),
    //   //frequency: const Duration(minutes: 16),
    //   inputData: {
    //     'string': getUserEmail(),
    //   },
    // );

    await Workmanager().registerPeriodicTask(
      'task_two_unique_name',
      'task_two',
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(minutes: 15),
    );

  }

  String getUserEmail() {
    final email = _authRepo.firebaseUser.value?.email;
    print("\t ----> getUserEmail() returns Email: ${email.toString()}");
    return email.toString();
  }
}
