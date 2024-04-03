import 'package:everyday_chronicles/src/features/core/controllers/background_service_controller.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:everyday_chronicles/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

final _backgroundService = Get.put(BackgroundServiceController());

void callbackDispatcher() {
  print(" ------> callbackDispatcher() function has been run");
  Workmanager().executeTask((taskName, inputData) async {
    final data = inputData as Map<String, dynamic>; // Ensure inputData is of type Map<String, dynamic>
    print(" ------> Before Switch statement");
    switch (taskName) {
      case 'task_one_create_dummy_data_service':
        {
          print("\t -------> Email: ${data['email']}");
          final email = data['email'];
          _backgroundService.taskOneCreateDummyDayDataService(email);
        }
        break;
      default:
    }
    return Future.value(true);
  });
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and AuthenticationRepository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());

  // Initialize Work manager (background services package)
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

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
