import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/cards/daily_record_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_alt),
          ),
        ],
        backgroundColor: myBackgroundLightColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              //bottomLeft: Radius.circular(25),
              //bottomRight: Radius.circular(25),
              ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            DailyRecordCard(
              cardIcon: Icons.tag_faces,
              cardDate: "Nov 16,\n2023",
              cardTitle: "Happy Day",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.greenAccent,
            ),
            DailyRecordCard(
              cardIcon: Icons.run_circle_outlined,
              cardDate: "Nov 15,\n2023",
              cardTitle: "Walked 4km",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.blue,
            ),
            DailyRecordCard(
              cardIcon: Icons.star,
              cardDate: "Nov 14,\n2023",
              cardTitle: "trip to Swat",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.orange,
            ),
            DailyRecordCard(
              cardIcon: Icons.tag_faces,
              cardDate: "Nov 16,\n2023",
              cardTitle: "Happy Day",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.greenAccent,
            ),
            DailyRecordCard(
              cardIcon: Icons.run_circle_outlined,
              cardDate: "Nov 15,\n2023",
              cardTitle: "Walked 4km",
              cardSubTitle:
                  "Just The dummy text to check the app working perfectly or not.",
              color: Colors.blue,
            ),
            DailyRecordCard(
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
