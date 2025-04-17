import 'package:everyday_chronicles/src/features/core/screens/home/fingerprint_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/backup_restore_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/privacy_policy_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/reminder_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/terms_screen.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/image_strings.dart';
import '../../../authentication/models/user_model.dart';
import '../../controllers/profile_controller.dart';
import 'customize_screen.dart';
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
    final profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              ThemeMode newThemeMode =
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
              Get.changeThemeMode(newThemeMode);
            },
            icon: Tooltip(
              message: Get.isDarkMode
                  ? 'Switch to Light Theme'
                  : 'Switch to Dark Theme',
              child: Icon(
                  Get.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode_outlined,
                  size: 30),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
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
                FutureBuilder(
                  future: profileController.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String fullName = "";
                      String email = "";
                      if (snapshot.hasData) {
                        UserModel user = snapshot.data as UserModel;
                        fullName = user.fullName ?? "";
                        email = user.email ?? "";
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const Spacer(),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withAlpha(25),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => const ProfileScreen());
                    },
                    icon: Icon(
                      Icons.person_outline,
                      size: 25,
                      color: Get.isDarkMode
                          ? Colors.tealAccent
                          : Colors.blue,
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
              icon: Icons.lock_outline,
              onPress: () {
                Get.to(() => const FingerprintScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Backup & restore",
              icon: Icons.backup,
              onPress: () {
                Get.to(() => const BackupScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Reminder",
              icon: Icons.notifications_outlined,
              onPress: () {
                Get.to(() => ReminderScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Customize Services",
              icon: Icons.build,
              onPress: () {
                Get.to(() => CustomizeScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Change theme",
              icon: Icons.color_lens_outlined,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Muslim",
              icon: Icons.mosque_outlined,
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
            const SizedBox(height: 10),
            ProfileMenuWidget(
              title: "Privacy Policy",
              icon: Icons.privacy_tip_outlined,
              onPress: () {
                Get.to(() => const PrivacyPolicyScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Terms & Conditions",
              icon: Icons.article_outlined,
              onPress: () {
                Get.to(() => const TermsScreen());
              },
            ),
            ProfileMenuWidget(
              title: "Rate us",
              icon: Icons.star_border_outlined,
              onPress: () {
                Get.snackbar(
                  "Rate Everyday Chronicles",
                  "You can rate once it's uploaded to the Play Store. Stay tuned!",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.blueGrey,
                  colorText: Colors.white,
                );
              },
            ),
            ProfileMenuWidget(
              title: "Share app",
              icon: Icons.share_outlined,
              onPress: () {
                Get.snackbar(
                  "Share App",
                  "You can't share this app right now because it is not uploaded on the Play Store yet. Thank you!",
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
                  "Logout",
                  "Are you sure you want to log out?",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  mainButton: TextButton(
                    onPressed: () {
                      AuthenticationRepository.instance.logout();
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
    );
  }
}

class MuslimWidget extends StatefulWidget {
  const MuslimWidget({super.key});

  @override
  State<MuslimWidget> createState() => _MuslimWidgetState();
}

class _MuslimWidgetState extends State<MuslimWidget> {
  bool isMuslim = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.mosque_outlined),
              const SizedBox(width: 20),
              Text(
                "Are you Muslim?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Switch(
            value: isMuslim,
            onChanged: (value) {
              setState(() {
                isMuslim = value;
              });
            },
            activeTrackColor: Colors.green,
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
