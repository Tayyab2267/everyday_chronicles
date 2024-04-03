import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../common_widgets/cards/daily_record_card.dart';
import '../../../../constants/colors.dart';
import '../../controllers/background_service_controller.dart';
import '../../controllers/selected_tags_controller.dart';
import '../card/card_screen.dart';
import 'filter_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SelectedTagsController _selectedTagsController =
      Get.put(SelectedTagsController());

  //final _backServiceCont = Get.put(BackgroundServiceController());

  // @override
  // void initState() {
  //   super.initState();
  //   //_backServiceCont.createDummyDayDataServiceFunction();
  // }

  // List of data for each DailyRecordCard
  final List<Map<String, dynamic>> dailyRecords = [
    {
      'cardIcon': Icons.tag_faces,
      'cardDate': "Mar 25,\n2024",
      'cardTitle': "Happy Day",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not Just The dummy text to",
      'color': Colors.greenAccent,
    },
    {
      'cardIcon': Icons.run_circle_outlined,
      'cardDate': "Nov 18,\n2023",
      'cardTitle': "Walked 4km",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not.",
      'color': Colors.blue,
    },
    {
      'cardIcon': Icons.star,
      'cardDate': "Nov 17,\n2023",
      'cardTitle': "trip to Swat",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not.",
      'color': Colors.orange,
    },
    {
      'cardIcon': Icons.tag_faces,
      'cardDate': "Nov 16,\n2023",
      'cardTitle': "Happy Day",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not.",
      'color': Colors.greenAccent,
    },
    {
      'cardIcon': Icons.run_circle_outlined,
      'cardDate': "Nov 15,\n2023",
      'cardTitle': "Walked 4km",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not.",
      'color': Colors.blue,
    },
    {
      'cardIcon': Icons.star,
      'cardDate': "Nov 14,\n2023",
      'cardTitle': "trip to Swat",
      'cardSubTitle':
      "Just The dummy text to check the app working perfectly or not.",
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    //_backServiceCont.createDummyDayDataService();
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 2,
        title: Text(
          "Home",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Workmanager().cancelAll();
            },
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
            // for filter tags
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
            ),
            const SizedBox(height: 10),
            // ListView builder for dynamically generating DailyRecordCards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyRecords.length,
              itemBuilder: (context, index) {
                final record = dailyRecords[index];
                return DailyRecordCard(
                  onTap: () {
                    //print("Card Clicked");
                    Get.to(
                          () => CardScreen(
                        cardIcon: record['cardIcon'],
                        color: record['color'],
                        cardDate: record['cardDate'],
                        cardTitle: record['cardTitle'],
                        cardSubTitle: record['cardSubTitle'],
                      ),
                    );
                  },
                  cardIcon: record['cardIcon'],
                  cardDate: record['cardDate'],
                  cardTitle: record['cardTitle'],
                  cardSubTitle: record['cardSubTitle'],
                  color: record['color'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
