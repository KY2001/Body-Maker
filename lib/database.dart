import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_app/data.dart';
import 'package:training_app/module.dart';

Future<void> getDatabase() async {
  String path = (await getDatabasesPath()) + dbName;
  if (db == '') db = await openDatabase(path, version: 1);
}

Future<void> initDatabase() async {
  /*
  await db.rawQuery('DROP TABLE IF EXISTS `exercise_records`');
  await db.rawQuery('DROP TABLE IF EXISTS `food_records`');
  await db.rawQuery('DROP TABLE IF EXISTS `records`');
  await db.rawQuery('DROP TABLE IF EXISTS `options`');
  await db.rawQuery('DROP TABLE IF EXISTS `exercise`');
  await db.rawQuery('DROP TABLE IF EXISTS `food`');
  */
  await db.rawQuery(''' 
  CREATE TABLE IF NOT EXISTS `exercise_records` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `time` TEXT NOT NULL,
  `exercise` TEXT NOT NULL,
  `weight` TEXT NOT NULL,
  `rep` TEXT NOT NULL,
  `set` TEXT NOT NULL
   )
  ''');
  await db.rawQuery('''
  CREATE TABLE IF NOT EXISTS `exercise` (
   `id` INTEGER PRIMARY KEY AUTOINCREMENT,
   `name` TEXT UNIQUE NOT NULL,
   `group` TEXT NOT NULL,
   `used_time` INTEGER NOT NULL
   )
   ''');
  await db.rawQuery('''
  CREATE TABLE IF NOT EXISTS `options` (
   `id` INTEGER PRIMARY KEY,
   `exercise` TEXT default 選択する,
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
   `minSet` TEXT default 1,
   `food` TEXT default 選択する,
   `amount` TEXT default 100
   )
   ''');
  await db.rawQuery(''' 
  CREATE TABLE IF NOT EXISTS `food_records` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `time` TEXT NOT NULL,
  `name` TEXT NOT NULL,
  `amount` TEXT NOT NULL,
  `calorie` TEXT NOT NULL,
  `protein` TEXT NOT NULL,
  `fat` TEXT NOT NULL,
  `carb` TEXT NOT NULL,
  `group` TEXT NOT NULL
   )
  ''');
  await db.rawQuery('''
  CREATE TABLE IF NOT EXISTS `food` (
   `id` INTEGER PRIMARY KEY AUTOINCREMENT,
   `name` TEXT UNIQUE NOT NULL,
   `calorie` TEXT NOT NULL,
   `protein` TEXT NOT NULL,
   `fat` TEXT NOT NULL,
   `carb` TEXT NOT NULL,
   `group` TEXT NOT NULL,
   `used_time` INTEGER NOT NULL
   )
   ''');
  await db.rawQuery('INSERT OR IGNORE INTO `options` (`id`) VALUES(1)');
  await db.rawQuery('SELECT * FROM `exercise` ORDER BY `used_time`').then((value) {
    for (var row in value) {
      exerciseList.add({'used_time': 0, 'name': row['name'], 'group': row['group']});
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
    food = value['food'];
    amount = double.parse(value['amount']);
  });
  await db.rawQuery('SELECT * FROM `food`').then((value) {
    for (var i in value) {
      foodList.add(i);
    }
  });
  await db.rawQuery('SELECT MIN(`time`) as min FROM `exercise_records`').then((value) {
    value = value[0]['min'];
    firstDay = timeDisAssemble2(value);
  });
  await db.rawQuery('SELECT MIN(`time`) as min FROM `food_records`').then((value) {
    value = value[0]['min'];
    firstDay =
        timeDisAssemble2(value).isBefore(firstDay) ? timeDisAssemble2(value) : firstDay;
  });
  await db.rawQuery('SELECT * FROM `exercise_records`').then((value) {
    exerciseRecords = value;
  });
  await db.rawQuery('SELECT * FROM `food_records`').then((value) {
    foodRecords = value;
  });
}
