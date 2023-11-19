import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/cards/daily_record_card.dart';
import '../../../../constants/colors.dart';
import '../../controllers/selected_tags_controller.dart';
import 'filter_screen.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final SelectedTagsController _selectedTagsController =
      Get.put(SelectedTagsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 2,
        title: Text(
          "Home Screen",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 20),
          ),
          IconButton(
            onPressed: () {
              FilterScreen.buildShowModalBottomSheet(context);
            },
            icon: const Icon(Icons.filter_list_alt, size: 20),
          ),
        ],
        backgroundColor: myBackgroundLightColor,
        leading: IconButton(
          onPressed: () {
            Get.to(
              () => const ProfileScreen(),
              transition: Transition.leftToRight,
              duration: const Duration(milliseconds: 400),
            );
          },
          icon: const Icon(Icons.person, size: 20),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Add Obx Here
            Obx(
              () => SizedBox(
                //if(_selectedTagsController.selectedTags.length)
                height:
                    _selectedTagsController.selectedTags.isNotEmpty ? 40 : 0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedTagsController.selectedTags.length,
                  itemBuilder: (context, index) {
                    final tag = _selectedTagsController.selectedTags[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        backgroundColor: Colors.blue.shade300,
                        //deleteIconColor: Colors.black,
                        label: Text(tag,
                            style: Theme.of(context).textTheme.bodyMedium),
                        onDeleted: () {
                          _selectedTagsController.selectedTags.remove(tag);
                        },
                      ),
                    );
                  },
                ),
              ),
            ), // Empty container if selectedTags is null
            const SizedBox(height: 10),
            const DailyRecordCard(
              cardIcon: Icons.tag_faces,
              cardDate: "Nov 19,\n2023",
              cardTitle: "Happy Day",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not Just The dummy text to",
              color: Colors.greenAccent,
            ),
            const DailyRecordCard(
              cardIcon: Icons.run_circle_outlined,
              cardDate: "Nov 18,\n2023",
              cardTitle: "Walked 4km",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.blue,
            ),
            const DailyRecordCard(
              cardIcon: Icons.star,
              cardDate: "Nov 17,\n2023",
              cardTitle: "trip to Swat",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.orange,
            ),
            const DailyRecordCard(
              cardIcon: Icons.tag_faces,
              cardDate: "Nov 16,\n2023",
              cardTitle: "Happy Day",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.greenAccent,
            ),
            const DailyRecordCard(
              cardIcon: Icons.run_circle_outlined,
              cardDate: "Nov 15,\n2023",
              cardTitle: "Walked 4km",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.blue,
            ),
            const DailyRecordCard(
              cardIcon: Icons.star,
              cardDate: "Nov 14,\n2023",
              cardTitle: "trip to Swat",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
