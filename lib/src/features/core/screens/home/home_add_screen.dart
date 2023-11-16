import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/colors.dart';

class HomeAddScreen extends StatefulWidget {
  const HomeAddScreen({super.key});

  @override
  State<HomeAddScreen> createState() => _HomeAddScreenState();
}

class _HomeAddScreenState extends State<HomeAddScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: myHomeScreenBackgroundColor,
      backgroundColor: Get.isDarkMode ? myHomeScreenBackgroundDarkColor : myHomeScreenBackgroundColor, // home screen Dark background color
      appBar: AppBar(
        foregroundColor: Colors.black,
        //elevation: 2,
        title: Text(
          "Nov 16, 2023",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.check, size: 20),
          ),
        ],
        backgroundColor: myBackgroundLightColor,
        leading: IconButton(
          onPressed: () {},
          icon: const FaIcon(FontAwesomeIcons.xmark, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, bottom: 50, right: 25, left: 25),
          child: Column(
            children: [
              // 1. Mood
              Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? myCardBackgroundDarkColor : myCardBackgroundLightColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the border radius as needed
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("How was your day?",
                        style: Theme.of(context).textTheme.titleLarge),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 2,
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.faceLaughBeam,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.faceLaughBeam),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.faceSmile),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.faceMeh),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.faceSadTear),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.faceAngry),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // 2. Write
              Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? myCardBackgroundDarkColor : myCardBackgroundLightColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the border radius as needed
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Write about today",
                        style: Theme.of(context).textTheme.titleLarge),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 2,
                      height: 20.0,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Get.isDarkMode ? Colors.white : Colors.grey.shade700,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Type your daily doing in it...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // 3. Photos
              Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? myCardBackgroundDarkColor : myCardBackgroundLightColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the border radius as needed
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Your photos",
                        style: Theme.of(context).textTheme.titleLarge),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 2,
                      height: 20.0,
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 100.0, // Adjust the height as needed
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: imageFileList.length,
                        itemBuilder: (context, index) {
                          return Image.file(File(imageFileList[index].path));
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          selectImages();
                        },
                        icon: const Icon(Icons.add_photo_alternate, size: 35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // 4. Recording
              Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? myCardBackgroundDarkColor : myCardBackgroundLightColor,
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the border radius as needed
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Record Audio",
                        style: Theme.of(context).textTheme.titleLarge),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 2,
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.mic,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
