import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/privacy_policy_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/image_strings.dart';
import 'setting_menu_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool isMuslimVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
            icon: Icon(
                Get.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(profileImage),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text("M Awais Shafi".toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text("awaisshafi.pk@gmail.com",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => const ProfileScreen());
                      },
                      icon: Icon(
                        LineAwesomeIcons.user_edit,
                        size: 25,
                        color: Get.isDarkMode ? Colors.tealAccent : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                  thickness: 2,
                  color:
                      Get.isDarkMode ? Colors.white24 : Colors.grey.shade200),
              ProfileMenuWidget(
                title: "Passcode",
                icon: LineAwesomeIcons.lock,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Backup & restore",
                icon: LineAwesomeIcons.database,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Reminder",
                icon: LineAwesomeIcons.bell,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Change theme",
                icon: LineAwesomeIcons.image,
                onPress: () {
                },
              ),
              ProfileMenuWidget(
                title: "Muslim",
                icon: LineAwesomeIcons.mosque,
                onPress: () {
                  setState(() {
                    isMuslimVisible = !isMuslimVisible;
                  });
                },
              ),
              Visibility(
                visible: isMuslimVisible,
                child: const MuslimWidget(),
              ),
              Divider(
                  thickness: 2,
                  color:
                      Get.isDarkMode ? Colors.white24 : Colors.grey.shade200),
              /// Document section below
              ///
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Privacy Policy",
                icon: LineAwesomeIcons.lock,
                onPress: () {
                  Get.to(() => const PrivacyPolicyScreen());
                },
              ),
              ProfileMenuWidget(
                title: "Terms & Conditions",
                icon: LineAwesomeIcons.sticky_note,
                onPress: () {
                  Get.to(() => const TermsScreen());
                },
              ),
              ProfileMenuWidget(
                title: "Rate us",
                icon: LineAwesomeIcons.star,
                onPress: () {
                  Get.snackbar(
                    "Rate Everyday Chronicles",
                    "You can be able to rate when we uploaded it on play store. So, stay tunned.",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                },
              ),
              ProfileMenuWidget(
                title: "Share app",
                icon: LineAwesomeIcons.share_square,
                onPress: () {
                  Get.snackbar(
                    "Share App",
                    "You cann't share this app right now because it is not uploaded on play store yet. Thank u",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                },
              ),
              ProfileMenuWidget(
                title: "Logout".toUpperCase(),
                icon: FontAwesomeIcons.arrowRightFromBracket,
                endIcon: false,
                textColor: Colors.redAccent,
                onPress: () {
                  Get.snackbar(
                    "Logout", // Title
                    "Are you sure you want to log out?", // Message
                    snackPosition: SnackPosition.BOTTOM,
                    // You can adjust the position as needed
                    duration: const Duration(seconds: 3),
                    // You can adjust the duration as needed
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    mainButton: TextButton(
                      onPressed: () {
                        Get.offAll(
                            () => const LoginScreen()); // Close the snackbar
                        // Add your logout logic here
                      },
                      child: Text(
                        "Confirm".toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class MuslimWidget extends StatefulWidget {
  const MuslimWidget({super.key, });

  @override
  State<MuslimWidget> createState() => _MuslimWidgetState();
}

class _MuslimWidgetState extends State<MuslimWidget> {

  bool isMuslim = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.mosque_outlined),
              const SizedBox(width: 20),
              Text("Are you Muslim?", style: Theme.of(context).textTheme.titleMedium,),
            ],
          ),
          Switch(
            value: isMuslim,
            onChanged: (value){
              setState(() {
                isMuslim = value;
              });
              //showToast(isMuslim ? "Switched ON" : "Switched OFF");
            },
            activeTrackColor: Colors.green,
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

}


