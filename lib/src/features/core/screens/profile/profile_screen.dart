import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/features/core/screens/profile/profile_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //foregroundColor: Colors.black,
        //elevation: 2,
        title: Text(
          "Profile Page",
          style: Theme.of(context)
              .textTheme
              .headlineSmall,
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage(profileImage),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("M Awais Shafi".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium),
              Text("awaisshafi.pk@gmail.com",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.isDarkMode ? Colors.white : myButtonBackgroundColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Edit Profile"),
                ),
              ),
              const SizedBox(height: 20),
              Divider(thickness: 2, color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade200),
              const SizedBox(height: 10),
              // Menu
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Language",
                icon: LineAwesomeIcons.language,
                onPress: () {},
              ),
              Divider(thickness: 2, color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade200),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: FontAwesomeIcons.info,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Help & Support",
                icon: FontAwesomeIcons.question,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Logout".toUpperCase(),
                icon: FontAwesomeIcons.arrowRightFromBracket,
                endIcon: false,
                textColor: Colors.redAccent,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
