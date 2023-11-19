import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import 'setting_menu_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
                      icon: const Icon(
                        LineAwesomeIcons.user_edit,
                        size: 25,
                        color: Colors.tealAccent,
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
              // Menu
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
                title: "Language",
                icon: LineAwesomeIcons.language,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Change theme",
                icon: LineAwesomeIcons.image,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Muslim",
                icon: LineAwesomeIcons.mosque,
                onPress: () {},
              ),
              Divider(
                  thickness: 2,
                  color:
                      Get.isDarkMode ? Colors.white24 : Colors.grey.shade200),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Privacy Policy",
                icon: LineAwesomeIcons.lock,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Terms of the service",
                icon: LineAwesomeIcons.sticky_note,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Rate us",
                icon: LineAwesomeIcons.star,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Share app",
                icon: LineAwesomeIcons.share_square,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Logout".toUpperCase(),
                icon: FontAwesomeIcons.arrowRightFromBracket,
                endIcon: false,
                textColor: Colors.redAccent,
                onPress: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
