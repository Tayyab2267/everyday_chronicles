import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:everyday_chronicles/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

taskTwo(){
  if (kDebugMode) {
    print("........................................");
    print("............. Task no 02 ...............");
    print("........................................");
  }
}
void callbackDispatcher() {
  print(" ------> callbackDispatcher() function has been run");
  Workmanager().executeTask((taskName, inputData) async {
    // Here you can perform the desired task based on taskName
    // For now, we'll just print some messages
    print(" ------> Before Switch statement");
    switch (taskName) {
      case 'task_two':
        taskTwo();
        break;
      case 'task_one':
        {
          // Print some debug information
          print("........................................");
          print("............. Task no 01 ...............");
          print(".....${inputData?['string']} ...........");
          print("........................................");
        }
        break;

      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Hive
  await Hive.initFlutter();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
      debugShowCheckedModeBanner: false,
      //home: SplashScreen(),
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
