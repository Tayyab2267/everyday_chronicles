import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../features/authentication/models/user_model.dart';
import '../../features/core/controllers/noti.dart';
import '../../features/core/controllers/sql_helper.dart';
import '../authentication_repository/authentication_repository.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Your account has been created.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<UserModel> getUserDetail(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }

  static Future<void> saveDataToFirestore() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final email = AuthenticationRepository.instance.getUserEmail();
    final database = await SQLHelper.db();
    final items = await database.query('items');

    for (final item in items) {
      try {
        final date = item[
            'date']; // Assuming 'date' is the field name for the unique date

        final itemRef = FirebaseFirestore.instance
            .collection('Backup')
            .doc(email)
            .collection('items')
            .doc(date.toString()); // Use 'date' as the document ID

        await itemRef.set({
          'date': item['date'],
          'icon': item['icon'],
          'userSelectMood': item['userSelectMood'],
          'title': item['title'],
          'subtitle': item['subtitle'],
          'thoughts': item['thoughts'],
          'summary': item['summary'],
          'weatherList': item['weatherList'],
          'userLocationList': item['userLocationList'],
          'callLocationList': item['callLocationList'],
          'prayerList': item['prayerList'],
        });

        print("Data has been backed up successfully.");
        Get.snackbar(
          "Success",
          "Data has been backed up successfully.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          barBlur: 0.4,
          colorText: Colors.white,
        );

        Noti.showBigTextNotification(
            title: "Backup Data",
            body: "Your Data has been backup.",
            fln: flutterLocalNotificationsPlugin);
      } catch (e) {
        print("Error saving data to Firestore: $e");
        Get.snackbar(
          "Error",
          "Error saving data to Firestore: $e",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          barBlur: 0.4,
          colorText: Colors.white,
        );
      }
    }
  }

  static Future<void> restoreDataFromFirestore() async {
    try {
      final email = AuthenticationRepository.instance.getUserEmail();
      final snapshot = await FirebaseFirestore.instance
          .collection('Backup')
          .doc(email)
          .collection('items')
          .get();

      final documents = snapshot.docs;

      for (final doc in documents) {
        final data = doc.data();
        final date = data[
            'date']; // Assuming 'date' is the field name for the unique date

        final subtitle = data['subtitle'] as String?;
        final thoughts = data['thoughts'] as String?;
        final summary = data['summary'] as String?;

        // Create or update item in the local database
        await SQLHelper.createItemForRestore(
          date,
          data['icon'] ?? '',
          data['userSelectMood'] ?? '',
          data['title'] ?? '',
          subtitle,
          thoughts,
          summary,
          data['weatherList'] ?? '',
          data['userLocationList'] ?? '',
          data['callLocationList'] ?? '',
          data['prayerList'] ?? '',
        );
      }

      print("Data has been restored successfully.");
      Get.snackbar(
        "Success",
        "Data has been restored successfully.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        barBlur: 0.4,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error restoring data from Firestore: $e");
      Get.snackbar(
        "Error",
        "Error restoring data from Firestore: $e",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        barBlur: 0.4,
        colorText: Colors.white,
      );
    }
  }
}
