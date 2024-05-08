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
      userSelectMood TEXT,
      title TEXT,
      subtitle TEXT,
      thoughts TEXT,
      weatherList TEXT,
      userLocationList TEXT,
      callLocationList TEXT
    )
    """;
    await database.execute(sqlCreateTableQuery);
    print("-----> Tables created successfully.");
  }

  static Future<void> updateTable() async {
    print("-----> Updating table...");
    final db = await SQLHelper.db();

    // Create a new table with the updated schema
    const migrationSql = '''
      CREATE TABLE items_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        date TEXT,
        icon TEXT,
        userSelectMood TEXT,
        title TEXT,
        subtitle TEXT,
        thoughts TEXT,
        weatherList TEXT,
        userLocationList TEXT,
        callLocationList TEXT
      )
    ''';
    await db.execute(migrationSql);

    // Copy data from the old table to the new one
    final data = await db.query('items');
    for (Map<String, dynamic> row in data) {
      await db.insert('items_new', row);
    }

    // Delete the old table
    await db.execute('DROP TABLE items');

    // Rename the new table to the original name
    await db.execute('ALTER TABLE items_new RENAME TO items');

    print("-----> Table updated successfully.");
  }

  static Future<int> createItem(String date, String icon, String userSelectMood,String title, String? subtitle, String? thoughts) async {
    print("-----> Creating item...");
    final db = await SQLHelper.db();
    final data = {'date': date, 'icon': icon, 'userSelectMood':userSelectMood, 'title': title, 'subtitle': subtitle, 'thoughts': thoughts};
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

  static Future<String?> getUserSelectMoodByDate(String date) async {
    print("-----> Getting userSelectMood by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['userSelectMood'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final userSelectMood = result.first['userSelectMood']; // Get the weatherList field
      if (userSelectMood != null) {
        return userSelectMood.toString(); // Convert to string if not null
      } else {
        return null; // Return null if weatherList is null
      }
    } else {
      return null; // Return null if no matching item is found
    }
  }

  static Future<String?> getSubtitleByDate(String date) async {
    print("-----> Getting subtitle by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['subtitle'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final subtitle = result.first['subtitle']; // Get the weatherList field
      if (subtitle != null) {
        return subtitle.toString(); // Convert to string if not null
      } else {
        return null; // Return null if weatherList is null
      }
    } else {
      return null; // Return null if no matching item is found
    }
  }
  static Future<String?> getThoughtsByDate(String date) async {
    print("-----> Getting Thoughts by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['thoughts'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final thoughts = result.first['thoughts']; // Get the weatherList field
      if (thoughts != null) {
        return thoughts.toString(); // Convert to string if not null
      } else {
        return null; // Return null if weatherList is null
      }
    } else {
      return null; // Return null if no matching item is found
    }
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

  static Future<String?> getUserLocationListByDate(String date) async {
    print("-----> Getting user location list by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['userLocationList'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final userLocationList = result.first['userLocationList']; // Get the userLocationList field
      if (userLocationList != null) {
        return userLocationList.toString(); // Convert to string if not null
      } else {
        return null; // Return null if weatherList is null
      }
    } else {
      return null; // Return null if no matching item is found
    }
  }

  static Future<String?> getCallLocationListByDate(String date) async {
    print("-----> Getting Call location list by date...");
    final db = await SQLHelper.db();
    final result = await db.query('items', columns: ['callLocationList'], where: "date = ?", whereArgs: [date], limit: 1);
    if (result.isNotEmpty) {
      final callLocationList = result.first['callLocationList']; // Get the userLocationList field
      if (callLocationList != null) {
        return callLocationList.toString(); // Convert to string if not null
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
      String date, String icon, String userSelectMood, String title, String? subtitle, String? thoughts) async {
    print("-----> Updating item by date...");
    final db = await SQLHelper.db();

    final data = {
      'icon': icon,
      'userSelectMood': userSelectMood,
      'title': title,
      'subtitle': subtitle,
      'thoughts': thoughts,
    };

    final result = await db.update('items', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  static Future<int> updateMoodIconByDate(
      String date, String icon) async {

    print("-----> Updating item icon by date...");
    final db = await SQLHelper.db();

    final data = {
      'icon': icon,
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

  static Future<int> updateItemUserLocationByDate(
      String date, String userLocationList) async {

    print("-----> Updating item User Location by date...");
    final db = await SQLHelper.db();

    final data = {
      'userLocationList': userLocationList,
    };

    final result = await db.update('items', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  static Future<int> updateItemCallLocationByDate(
      String date, String callLocationList) async {

    print("-----> Updating item Call Location by date...");
    final db = await SQLHelper.db();

    final data = {
      'callLocationList': callLocationList,
    };

    final result = await db.update('items', data, where: "date = ?", whereArgs: [date]);
    return result;
  }

  static Future<int> updateItem(
      int id, String icon, String userSelectMood, String title, String? subtitle, String? thoughts) async {
    print("-----> Updating item by ID...");
    final db = await SQLHelper.db();

    final data = {
      'icon': icon,
      'userSelectMood': userSelectMood,
      'title': title,
      'subtitle': subtitle,
      'thoughts': thoughts,
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
