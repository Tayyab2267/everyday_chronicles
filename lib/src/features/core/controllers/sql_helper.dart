import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../../../firebase_options.dart';

class SQLHelper {

  static Future<sql.Database> db() async {
    ///
    // Initialize Firebase and AuthenticationRepository
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AuthenticationRepository());
    ///
    final authRepo = AuthenticationRepository.instance;
    final email = authRepo.getUserEmail();
    String dbName = "$email.db";
    //String dbName = "awaisshafi6164@gmail.com.db";
    print("-----> Opening database...");
    return sql.openDatabase(
        dbName,
        version: 1,
        onCreate: (sql.Database database, int version) async {
          print("... creating a table ...");
          await createTables(database);
          print("-----> Table created successfully.");
        });
  }

  static Future<void> createTables(sql.Database database) async {
    print("-----> Creating tables...");
    String sqlCreateTableQuery = """CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      date TEXT,
      icon TEXT,
      title TEXT,
      subtitle TEXT,
      weatherList TEXT
    )
    """;
    await database.execute(sqlCreateTableQuery);
    print("-----> Tables created successfully.");
  }

  static Future<int> createItem(String date, String icon, String title, String? subtitle) async {
    print("-----> Creating item...");
    final db = await SQLHelper.db();
    final data = {'date': date, 'icon': icon, 'title': title, 'subtitle': subtitle};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print(" -----> Item inserted with ID: $id");
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    print("-----> Getting items...");
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "date DESC");
  }

  static Future<List<Map<String, dynamic>>> getItemByDate(String date) async {
    print("-----> Getting item by date...");
    final db = await SQLHelper.db();
    return db.query('items', where: "date = ?", whereArgs: [date], limit: 1);
  }

  static Future<String?> getWeatherListByDate(String date) async {
    print("-----> Getting weather list by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['weatherList'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final weatherList = result.first['weatherList']; // Get the weatherList field
      if (weatherList != null) {
        return weatherList.toString(); // Convert to string if not null
      } else {
        return null; // Return null if weatherList is null
      }
    } else {
      return null; // Return null if no matching item is found
    }
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    print("-----> Getting item by ID...");
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItemByDate(
      String date, String icon, String title, String? subtitle) async {
    print("-----> Updating item by date...");
    final db = await SQLHelper.db();

    final data = {
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
    };

    final result = await db.update('items', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  static Future<int> updateItemWeatherByDate(
      String date, String weatherList) async {

    print("-----> Updating item weather by date...");
    final db = await SQLHelper.db();

    final data = {
      'weatherList': weatherList,
    };

    final result = await db.update('items', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  static Future<int> updateItem(
      int id, String icon, String title, String? subtitle) async {
    print("-----> Updating item by ID...");
    final db = await SQLHelper.db();

    final data = {
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
    };

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  static Future<void> deleteItem(int id) async{
    print("-----> Deleting item...");
    final db = await SQLHelper.db();
    try{
      await db.delete("items", where: "id = ?", whereArgs: [id]);
      print("-----> Item deleted successfully.");
    } catch(er){
      debugPrint("Something went wrong when deleting an item: $er");
    }
  }

  static Future<void> deleteDatabase() async {
    print("-----> Deleting database...");
    try {
      final authRepo = AuthenticationRepository.instance;
      final email = authRepo.getUserEmail();
      String dbName = "$email.db";

      if (dbName.isNotEmpty) {
        // Delete the database file
        await sql.deleteDatabase(dbName);
        print("-----> Database deleted successfully");
      } else {
        print("-----> Database does not exist");
      }
    } catch (error) {
      print("-----> Error deleting database: $error");
    }
  }
}
