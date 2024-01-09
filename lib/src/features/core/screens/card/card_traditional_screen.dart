import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';

class CardTraditionalScreen extends StatelessWidget {
  const CardTraditionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String paraTrad =
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.";

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("Nov 19, 2023"),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.tag_faces, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 80, left: 20, right: 20),
          child: Text(
            paraTrad,
            textAlign: TextAlign.justify,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20.0),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              backgroundColor: color1,
              tooltip: "Close Traditional Page",
              child: const FaIcon(FontAwesomeIcons.book, color: Colors.white),
            ),
          ),
          // FloatingActionButton(
          //   onPressed: () {
          //     if (kDebugMode) {
          //       print('Floating button pressed!');
          //     }
          //   },
          //   backgroundColor: color1,
          //   tooltip: "Opens Add page",
          //   child: const Icon(Icons.add, color: Colors.white),
          // ),
        ],
      ),
    );
  }
}
