import 'dart:developer';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  DBHelper.internal();

  static final DBHelper instance = DBHelper.internal();

  factory DBHelper() => instance;
  static String noteTable = "univ";
  final _version = 3;
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'univ.db');
    log(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS `events` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
          "`event_name` varchar(255)  NOT NULL,`event_date` datetime DEFAULT NULL,`event_bio` longtext ,"
          "`event_location` varchar(255)  DEFAULT NULL,`event_image` varchar(255)  DEFAULT NULL,"
          "`event_category` int DEFAULT NULL,`event_objective` longtext ,`event_live_link` varchar(512)  DEFAULT NULL,"
          "`event_detail_header` varchar(255)  DEFAULT NULL,`event_registration_available` tinyint(1) DEFAULT '1',"
          "`parent_id` int NOT NULL DEFAULT '0',`created_at` timestamp NULL DEFAULT NULL,"
          "`updated_at` timestamp NULL DEFAULT NULL,name varchar(1000),description text,icon text);");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS `sports` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`name` varchar(255)  NOT NULL,"
          "`description` varchar(255)  DEFAULT NULL,`parent` int NOT NULL DEFAULT '0',`icon` varchar(255)  DEFAULT NULL,"
          "`created_at` timestamp NULL DEFAULT NULL,`updated_at` timestamp NULL DEFAULT NULL);");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS `event_gallery` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`event_id` int NOT NULL,"
          "`image` varchar(512) NOT NULL,`image_priority` int DEFAULT NULL,`event_video` varchar(512) DEFAULT NULL,"
          "`video_priority` int DEFAULT NULL,`created_at` datetime DEFAULT NULL,`updated_at` datetime DEFAULT NULL);");

      await db.execute(
          "CREATE TABLE `sliders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,"
          "`image` varchar(512) NOT NULL);");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS `event_partners` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`event_id` int DEFAULT NULL,"
          "`partner_name` varchar(250) DEFAULT NULL,`partner_logo` varchar(250) DEFAULT NULL,`created_at` datetime DEFAULT NULL,"
          "`updated_at` datetime DEFAULT NULL)");

      await db.execute(
          "CREATE TABLE  IF NOT EXISTS `user_files` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`user_id` int DEFAULT NULL,"
          "`file_type` tinyint(1) DEFAULT NULL,`file_path` varchar(250) DEFAULT NULL,`title` varchar(512) DEFAULT NULL,"
          "`description` varchar(1000) DEFAULT NULL,`tags` varchar(1000) DEFAULT NULL,`created_at` datetime DEFAULT NULL,"
          "`updated_at` datetime DEFAULT NULL)");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS `event_result` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`user_id` int DEFAULT NULL,"
          "`event_id` int DEFAULT NULL,`event_result_key` varchar(255) DEFAULT NULL,`event_result_value` varchar(255) DEFAULT NULL,"
          "`created_at` datetime DEFAULT NULL,`updated_at` datetime DEFAULT NULL)");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS `quotes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`author` varchar(100) DEFAULT NULL,"
          "`category` varchar(100) DEFAULT NULL,`quote` varchar(2500) DEFAULT NULL,`created_at` datetime DEFAULT NULL,"
          "`updated_at` datetime DEFAULT NULL)");
      await db.execute('''
  CREATE TABLE IF NOT EXISTS event_result (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER DEFAULT NULL,
    event_id INTEGER DEFAULT NULL,
    event_result_key VARCHAR(255) DEFAULT NULL,
    event_result_value VARCHAR(255) DEFAULT NULL,
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL
  )
''');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < newVersion) {
        log("Version Upgrade");
      }
    });
    log('db initialize');
    return openDb;
  }
}
