import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_app/data.dart';

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

DateTime timeDisAssemble2(String time) {
  List<int> timeSplit = time.split(" ").map((value) => int.parse(value)).toList();
  return DateTime(timeSplit[0], timeSplit[1], timeSplit[2], timeSplit[3], timeSplit[4]);
}

String dateTimeToString(DateTime time) {
  String ret =
      "${time.year} ${time.month.toString().padLeft(2, "0")} ${time.day.toString().padLeft(2, "0")} ${time.hour.toString().padLeft(2, "0")} ${time.minute.toString().padLeft(2, "0")}";
  return ret;
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class MySelectionItem extends StatelessWidget {
  final String? title;
  final bool isForList;

  const MySelectionItem({Key? key, this.title, this.isForList = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: const EdgeInsets.all(10.0),
            )
          : Card(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title!,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }
}
