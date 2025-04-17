import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Make sure this package is properly imported

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final bool endIcon;
  final Color? textColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade200,
        ),
        child: Icon(
          icon,
          color: Get.isDarkMode ? Colors.tealAccent : Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.arrow_forward, // Replaced with an available icon
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
