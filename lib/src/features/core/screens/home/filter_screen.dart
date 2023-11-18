import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import '../../controllers/selected_tags_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();

  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      builder: (context) => const FilterScreen(),
    );
  }
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> tags = [
    "Location",
    "Running",
    "Sleep",
    "Images",
    "Call & Messages",
    "Mood 1",
    "Mood 2",
    "Mood 3",
    "Mood 4",
    "Mood 5"
  ];

  final SelectedTagsController _selectedTagsController =
      Get.put(SelectedTagsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
      height: 500,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(filterTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date Range: ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Start Date",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "End Date",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Tag".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10.0),
                // Add tags here
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: tags
                      .map(
                        (myTag) => FilterChip(
                          backgroundColor: Get.isDarkMode ? Colors.white24 : Colors.grey.shade200,
                          selectedColor: Colors.blue,
                          label: Text(myTag, style: Theme.of(context).textTheme.bodyMedium,),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTagsController.selectedTags.add(myTag);
                              } else {
                                _selectedTagsController.selectedTags
                                    .remove(myTag);
                              }
                            });
                          },
                          selected: _selectedTagsController.selectedTags
                              .contains(myTag),
                        ),
                      )
                      .toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
