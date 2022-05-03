import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqflite/sqflite.dart';

String dbName = "/training_memo.db";
AudioCache audioPlayer = AudioCache();
dynamic db;
double volume = 1.0;
List<TableRow> recordsTodayTable = [];
List<String> exerciseList = ['スクワット'];
String exercise = 'ベンチプレス';
double weight = 45;
int rep = 10;
int set = 3;
double scoreToday = 0.0;
double minWeight = 1;
double maxWeight = 100;
double intervalWeight = 1;
double minRep = 1;
double maxRep = 20;
double minSet = 1;
double maxSet = 10;

Future<void> getDatabase() async {
  String path = (await getDatabasesPath()) + dbName;
  db = await openDatabase(path, version: 1);
}

Future<void> initDatabase() async {
  await db.rawQuery('DROP TABLE IF EXISTS `record`');
  await db.rawQuery('DROP TABLE IF EXISTS `exercise`');
  await db.rawQuery('DROP TABLE IF EXISTS `options`');
  await db.rawQuery(''' 
  CREATE TABLE IF NOT EXISTS `record` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `time` TEXT,
  `exercise` TEXT,
  `weight` TEXT,
  `rep` TEXT,
  `set` TEXT
   )
  ''');
  await db.rawQuery('''
  CREATE TABLE IF NOT EXISTS `exercise` (
   `id` INTEGER PRIMARY KEY AUTOINCREMENT,
   `exercise` TEXT,
   `used_time` INTEGER
   )
   ''');
  await db.rawQuery('''
  CREATE TABLE IF NOT EXISTS `options` (
   `id` INTEGER PRIMARY KEY,
   `exercise` TEXT default ベンチプレス,
   `weight` TEXT default 10,
   `rep` TEXT default 10,
   `set` TEXT default 3,
   `volume` TEXT default 1,
   `maxWeight` TEXT default 100,
   `minWeight` TEXT default 1,
   `intervalWeight` TEXT default 1,
   `maxRep` TEXT default 20,
   `minRep` TEXT default 1,
   `maxSet` TEXT default 10,
   `minSet` TEXT default 1)
   ''');
  await db.rawQuery(
      'INSERT INTO `exercise` (`exercise`, used_time) SELECT "ベンチプレス", "0" WHERE NOT EXISTS (SELECT * FROM `exercise`)');
  await db.rawQuery('INSERT OR IGNORE INTO `options` (`id`) VALUES(1)');
  await db.rawQuery('SELECT * FROM `exercise` ORDER BY `used_time`').then((value) {
    for (var row in value) {
      exerciseList.add(row['exercise']);
    }
  });
  await db.rawQuery('SELECT * FROM `options`').then((value) {
    value = value[0];
    exercise = value['exercise'];
    weight = double.parse(value['weight']);
    rep = double.parse(value['rep']).toInt();
    set = double.parse(value['set']).toInt();
    maxWeight = double.parse(value['maxWeight']);
    minWeight = double.parse(value['minWeight']);
    intervalWeight = double.parse(value['intervalWeight']);
    maxRep = double.parse(value['maxRep']);
    minRep = double.parse(value['minRep']);
    maxSet = double.parse(value['maxSet']);
    minSet = double.parse(value['minSet']);
  });
}

Map<String, String> timeDisAssemble(String time) {
  List<String> timeSplit = time.split(" ");
  return {
    "year": timeSplit[0],
    "month": timeSplit[1],
    "day": timeSplit[2],
    "hour": timeSplit[3],
    "minute": timeSplit[4],
    "hour:minute": timeSplit[3].padLeft(2, '0') + ":" + timeSplit[4].padLeft(2, '0'),
  };
}
