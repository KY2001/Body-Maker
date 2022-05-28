import 'dart:math';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:overlay_support/overlay_support.dart';
import '../module.dart';
import '../database.dart';
import 'package:training_app/data.dart';
import 'package:smart_select/smart_select.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:audioplayers/audioplayers.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await getDatabase();
      await initDatabase();
      await updateExerciseData();
      await updateFoodData();
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    updateExerciseData();
    updateFoodData();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("アプリ名", textScaleFactor: 1.1),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  label: const Text('設定', textScaleFactor: 1.2),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    enableFeedback: false,
                  ),
                  onPressed: () {
                    audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                    Navigator.of(context).pushNamed("/optionalPage");
                  },
                ),
              ],
            ),
          ),
          body: (() {
            if (bottomBarIndex == 0) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("本日の食事", textScaleFactor: 1.4),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                            border: TableBorder.all(color: Colors.black),
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: foodRecordsTodayTable),
                      ),
                      Text.rich(TextSpan(
                        style: const TextStyle(fontSize: 21),
                        children: [
                          const TextSpan(text: "摂取カロリー: "),
                          TextSpan(
                              text: "${calorieToday.toInt()}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " [kcal]"),
                        ],
                      )),
                      Text.rich(TextSpan(
                        style: const TextStyle(fontSize: 21),
                        children: [
                          const TextSpan(text: "PFCバランス: "),
                          TextSpan(
                              text: "${pfcBalance[0]}:${pfcBalance[1]}:${pfcBalance[2]}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                      const SizedBox(height: 300),
                    ]),
              );
            } else if (bottomBarIndex == 1) {
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    const Text("本日のトレーニング", textScaleFactor: 1.4),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20.0),
                      child: Table(
                          border: TableBorder.all(color: Colors.black),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: exerciseRecordsTodayTable),
                    ),
                    Text.rich(TextSpan(
                      style: const TextStyle(fontSize: 21),
                      children: [
                        const TextSpan(text: "消費カロリー: "),
                        TextSpan(
                            text: exerciseCalorie.toStringAsFixed(0),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: " [kcal]"),
                      ],
                    )),
                    Text.rich(TextSpan(
                      style: const TextStyle(fontSize: 21),
                      children: [
                        const TextSpan(text: "総強度: "),
                        TextSpan(
                            text: "${exerciseVolume.toInt()}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: " [kg・rep・set]"),
                      ],
                    )),
                    const SizedBox(height: 300),
                  ]));
            } else if (bottomBarIndex == 2) {
              return TableCalendar(
                  locale: 'ja_JP',
                  weekendDays: const [],
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: focusedDay,
                  eventLoader: (DateTime day) {
                    List<Event> ret = [];
                    for (var i in foodRecords) {
                      DateTime recordTime = timeDisAssemble2(i['time']);
                      if (recordTime.isSameDate(day)) {
                        ret.add(const Event('temp'));
                      }
                    }
                    return ret;
                  },
                  calendarFormat: calendarFormat,
                  calendarStyle: const CalendarStyle(
                      isTodayHighlighted: false,
                      outsideDaysVisible: false,
                      markerDecoration: BoxDecoration(color: Colors.white)),
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  onDaySelected: (_selectedDay, _focusedDay) {
                    if (!isSameDay(selectedDay, _selectedDay)) {
                      setState(() {
                        selectedDay = _selectedDay;
                        focusedDay = _focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (calendarFormat != format) {
                      calendarFormat = format;
                    }
                  },
                  onPageChanged: (_focusedDay) {
                    focusedDay = _focusedDay;
                  });
            }
          })(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: '食事',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'トレーニング',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: '分析',
              ),
            ],
            currentIndex: bottomBarIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (value) {
              bottomBarIndex = value;
            },
          ),
          floatingActionButton: (() {
            if (bottomBarIndex == 0) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      width: 150,
                      height: 90,
                      child: FloatingActionButton.extended(
                        heroTag: "hero1",
                        onPressed: () {
                          audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                          displayEditFoodPopup(context);
                        },
                        enableFeedback: false,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        isExtended: true,
                        label: const Text(
                          '食事の編集',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                    )),
                SizedBox(
                  width: 150,
                  height: 90,
                  child: FloatingActionButton.extended(
                    heroTag: "hero2",
                    onPressed: () {
                      if (foodList.isEmpty) {
                        showSimpleNotification(
                          const Text("編集ボタンから食事を追加して下さい！", style: TextStyle(color: Colors.white)),
                          background: Colors.red,
                          position: NotificationPosition.bottom,
                          slideDismissDirection: DismissDirection.down,
                        );
                      } else {
                        audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                        displayAddFoodRecordPopup(context);
                      }
                    },
                    enableFeedback: false,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                    isExtended: true,
                    label: const Text(
                      '記録する',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    icon: const Icon(Icons.done),
                  ),
                ),
              ]);
            } else if (bottomBarIndex == 1) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      width: 150,
                      height: 90,
                      child: FloatingActionButton.extended(
                        heroTag: "hero1",
                        onPressed: () {
                          audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                          displayEditExercisePopup(context);
                        },
                        enableFeedback: false,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        isExtended: true,
                        label: const Text(
                          '種目の編集',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                    )),
                SizedBox(
                  width: 150,
                  height: 90,
                  child: FloatingActionButton.extended(
                    heroTag: "hero2",
                    onPressed: () {
                      if (exerciseList.isEmpty) {
                        showSimpleNotification(
                          const Text("編集ボタンから種目を追加して下さい！", style: TextStyle(color: Colors.white)),
                          background: Colors.red,
                          position: NotificationPosition.bottom,
                          slideDismissDirection: DismissDirection.down,
                        );
                      } else {
                        audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                        displayAddExerciseRecordPopup(context);
                      }
                    },
                    enableFeedback: false,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                    isExtended: true,
                    label: const Text(
                      '記録する',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    icon: const Icon(Icons.done),
                  ),
                ),
              ]);
            }
          })(),
        ));
  }

  Future<void> updateFoodData() async {
    if (db == '') await getDatabase();
    List<TableRow> _recordsTodayTable = [
      const TableRow(children: [
        Center(child: Text(' 食品名 ')),
        Center(child: Text(' 摂取量 ')),
        Center(child: Text(' カロリー ')),
      ])
    ];

    List<Map> recordsToday = await db.rawQuery(
        'SELECT * FROM `food_records` WHERE `time` LIKE "${dateTimeToString(DateTime.now()).substring(0, 10)}%"');
    for (var i in recordsToday) {
      List<Widget> children = [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Text(
                    i["exercise"].toString().length <= 12
                        ? ' ${i["name"].toString().substring(0, min(12, i["name"].toString().length))} '
                        : ' ${i["name"].toString().substring(0, min(11, i["name"].toString().length))}… ',
                    textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(child: Text(' ${double.parse(i["amount"]).round()} g ', textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(child: Text(' ${double.parse(i["calorie"]).round()} kcal ', textScaleFactor: 1.1))),
      ];
      _recordsTodayTable.add(TableRow(
        children: children,
      ));
    }
    setState(() => foodRecordsTodayTable = _recordsTodayTable);
    calorieToday = 0;
    for (var i in recordsToday) {
      calorieToday += double.parse(i['calorie'].toString());
    }
    List<double> _pfcBalance = [0, 0, 0];
    for (var i in recordsToday) {
      _pfcBalance[0] += double.parse(i['protein']);
      _pfcBalance[1] += double.parse(i['fat']);
      _pfcBalance[2] += double.parse(i['carb']);
    }
    double _pfcSum = _pfcBalance.reduce((a, b) => a + b);
    for (var i = 0; i < 3; i++) {
      pfcBalance[i] = _pfcSum == 0 ? 0 : (_pfcBalance[i] / _pfcSum * 10).round();
    }
  }

  Future<void> updateExerciseData() async {
    if (db == '') await getDatabase();
    List<TableRow> _recordsTodayTable = [
      const TableRow(children: [
        Center(child: Text('  時間  ')),
        Center(child: Text(' 種目 ')),
        Center(child: Text(' 重量 ')),
        Center(child: Text(' 回数 ')),
        Center(child: Text(' セット数 ', textScaleFactor: 0.9)),
      ])
    ];

    List<Map> recordsToday = await db.rawQuery(
        'SELECT * FROM `exercise_records` WHERE `time` LIKE "${dateTimeToString(DateTime.now()).substring(0, 10)}%"');
    for (var i in recordsToday) {
      List<Widget> children = [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child:
                Center(child: Text(' ${timeDisAssemble(i["time"])['hour:minute']} ', textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Text(
                    i["exercise"].toString().length <= 8
                        ? ' ${i["exercise"].toString().substring(0, min(8, i["exercise"].toString().length))} '
                        : ' ${i["exercise"].toString().substring(0, min(7, i["exercise"].toString().length))}… ',
                    textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Text(
                    ' ${double.parse(i["weight"]) - double.parse(i["weight"]).round() == 0 ? double.parse(i["weight"]).round() : double.parse(i["weight"]).toStringAsFixed(1)} ',
                    textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(child: Text(' ${double.parse(i["rep"]).round()} ', textScaleFactor: 1.1))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(child: Text(' ${double.parse(i["set"]).round()} ', textScaleFactor: 1.1))),
      ];
      _recordsTodayTable.add(TableRow(
        children: children,
      ));
    }
    setState(() => exerciseRecordsTodayTable = _recordsTodayTable);
    exerciseVolume = 0;
    for (var i in recordsToday) {
      exerciseVolume += (double.parse(i['weight'].toString()) *
          double.parse(i['rep'].toString()) *
          double.parse(i['set'].toString()));
    }
    exerciseCalorie = 0;
    if (recordsToday.length > 1) {
      double _minute = 60 *
          (double.parse(timeDisAssemble(recordsToday.last['time'])['hour']!) -
              double.parse(timeDisAssemble(recordsToday.first['time'])['hour']!));
      _minute += double.parse(timeDisAssemble(recordsToday.last['time'])['minute']!) -
          double.parse(timeDisAssemble(recordsToday.first['time'])['minute']!);
      exerciseCalorie = 100 / 30 * _minute;
    }
  }

  Future<void> displayAddFoodRecordPopup(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('食品'),
                    Center(
                        child: Stack(children: <Widget>[
                      Center(
                          child: Container(
                        height: 34,
                        width: 230,
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          Text(
                            exercise.length <= 16 ? food : food.substring(0, 15) + '...',
                            textScaleFactor: 0.9,
                            style: const TextStyle(color: Colors.white),
                          )
                        ]),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      )),
                      Center(
                          child: Container(
                              height: 40,
                              width: 230,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: SmartSelect<String>.single(
                                  title: '',
                                  placeholder: '',
                                  value: '',
                                  onChange: (value) {
                                    if (value.value != '') {
                                      setState(() {
                                        food = value.value;
                                      });
                                      db.rawQuery('UPDATE `options` SET `food` = "${value.value}"');
                                      value.value = '';
                                    }
                                  },
                                  choiceItems: S2Choice.listFrom<String, Map>(
                                    source: foodList,
                                    value: (index, item) => item['name'],
                                    title: (index, item) => item['name'],
                                    group: (index, item) => item['group'],
                                  ),
                                  modalType: S2ModalType.fullPage,
                                  choiceGrouped: true,
                                  modalFilter: true,
                                  modalFilterAuto: true,
                                  modalHeaderStyle: S2ModalHeaderStyle(
                                    backgroundColor: Colors.grey[850],
                                    textStyle: const TextStyle(color: Colors.white),
                                    iconTheme: const IconThemeData(color: Colors.white),
                                    actionsIconTheme: const IconThemeData(color: Colors.white),
                                  ),
                                  modalStyle: S2ModalStyle(backgroundColor: Colors.grey[850]),
                                  choiceStyle: const S2ChoiceStyle(
                                      titleStyle: TextStyle(color: Colors.white), activeColor: Colors.white),
                                  tileBuilder: (context, state) {
                                    return S2Tile.fromState(
                                      state,
                                      leading: const Text(''),
                                      trailing: const Text(''),
                                    );
                                  })))
                    ])),
                    const Text('摂取量'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: amount.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                amount = double.parse(value);
                                db.rawQuery('UPDATE `options` SET `amount` = "$value"');
                              },
                              decoration: InputDecoration(
                                suffix: const Text('[g]'),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false, // タッチ音をオフ
                  ),
                  child: const Text('保存'),
                  onPressed: () {
                    if (food != '' && amount != 0) {
                      audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                      String now = dateTimeToString(DateTime.now());
                      for (var i in foodList) {
                        if (i['name'] == food) {
                          Future(() async {
                            await db.rawQuery('''
                            INSERT INTO `food_records` 
                            (`time`, `name`, `amount`, `calorie`, `protein`, `fat`, `carb`, `group`) 
                            VALUES("$now", "${i['name']}", "$amount", 
                            "${double.parse(i['calorie']) * amount / 100}",
                            "${double.parse(i['protein']) * amount / 100}",
                            "${double.parse(i['fat']) * amount / 100}",
                            "${double.parse(i['carb']) * amount / 100}",
                            "${i['group']}")''');
                          });
                          break;
                        }
                      }
                      db.rawQuery('UPDATE `food` SET `used_time` = `used_time` + 1 WHERE `name` = "$food"');
                      updateFoodData();
                      showSimpleNotification(
                        const Text("保存しました！", style: TextStyle(color: Colors.white)),
                        background: Colors.green,
                        position: NotificationPosition.bottom,
                        slideDismissDirection: DismissDirection.down,
                      );
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> displayAddExerciseRecordPopup(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(children: <Widget>[
                      const Text('種目'),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        label: const Text('設定', textScaleFactor: 1.2),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          enableFeedback: false,
                        ),
                        onPressed: () {
                          audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                          Navigator.of(context).pushNamed("/optionalPage");
                        },
                      )
                    ]),
                    Center(
                        child: Stack(children: <Widget>[
                      Center(
                          child: Container(
                        height: 34,
                        width: 230,
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          Text(
                            exercise.length <= 16 ? exercise : exercise.substring(0, 15) + '...',
                            textScaleFactor: 0.9,
                            style: const TextStyle(color: Colors.white),
                          )
                        ]),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      )),
                      Center(
                          child: Container(
                              height: 40,
                              width: 230,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: SmartSelect<String>.single(
                                  title: '',
                                  placeholder: '',
                                  value: '',
                                  onChange: (value) {
                                    if (value.value != '') {
                                      setState(() {
                                        exercise = value.value;
                                      });
                                      db.rawQuery('UPDATE `options` SET `exercise` = "${value.value}"');
                                      value.value = '';
                                    }
                                  },
                                  choiceItems: S2Choice.listFrom<String, Map>(
                                    source: exerciseList,
                                    value: (index, item) => item['name'],
                                    title: (index, item) => item['name'],
                                    group: (index, item) => item['group'],
                                  ),
                                  modalType: S2ModalType.fullPage,
                                  choiceGrouped: true,
                                  modalFilter: true,
                                  modalFilterAuto: true,
                                  modalHeaderStyle: S2ModalHeaderStyle(
                                    backgroundColor: Colors.grey[850],
                                    textStyle: const TextStyle(color: Colors.white),
                                    iconTheme: const IconThemeData(color: Colors.white),
                                    actionsIconTheme: const IconThemeData(color: Colors.white),
                                  ),
                                  modalStyle: S2ModalStyle(backgroundColor: Colors.grey[850]),
                                  choiceStyle: const S2ChoiceStyle(
                                      titleStyle: TextStyle(color: Colors.white), activeColor: Colors.white),
                                  tileBuilder: (context, state) {
                                    return S2Tile.fromState(
                                      state,
                                      leading: const Text(''),
                                      trailing: const Text(''),
                                    );
                                  })))
                    ])),
                    Text('重量: ${weight.toStringAsFixed(1)} [kg]'),
                    Slider(
                      value: weight,
                      min: minWeight,
                      max: maxWeight,
                      divisions: max(1, (maxWeight - minWeight) ~/ intervalWeight),
                      label: weight.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          weight = value;
                        });
                        db.rawQuery('UPDATE `options` SET `weight` = "$value"');
                      },
                    ),
                    Text('回数/セット数: $rep [rep]'),
                    Slider(
                      value: rep.toDouble(),
                      min: minRep,
                      max: maxRep,
                      divisions: (maxRep - minRep).toInt(),
                      label: rep.toString(),
                      onChanged: (value) {
                        setState(() {
                          rep = value.toInt();
                        });
                        db.rawQuery('UPDATE `options` SET `rep` = "$value"');
                      },
                    ),
                    Text('セット数: $set [set]'),
                    Slider(
                      value: set.toDouble(),
                      min: minSet,
                      max: maxSet,
                      divisions: (maxSet - minSet).toInt(),
                      label: set.toString(),
                      onChanged: (value) {
                        setState(() {
                          set = value.toInt();
                        });
                        db.rawQuery('UPDATE `options` SET `set` = "$value"');
                      },
                    ),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false, // タッチ音をオフ
                  ),
                  child: const Text('保存'),
                  onPressed: () {
                    audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                    String now =
                        "${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day} ${DateTime.now().hour} ${DateTime.now().minute}";
                    db.rawQuery(
                        'INSERT INTO `exercise_records` (`time`, `exercise`, `weight`, `rep`, `set`) VALUES("$now", "$exercise", "${weight.toStringAsFixed(1)}", "$rep", "$set")');
                    db.rawQuery(
                        'UPDATE `exercise` SET `used_time` = `used_time` + 1 WHERE `name` = "$exercise"');
                    updateExerciseData();
                    showSimpleNotification(
                      const Text("保存しました！", style: TextStyle(color: Colors.white)),
                      background: Colors.green,
                      position: NotificationPosition.bottom,
                      slideDismissDirection: DismissDirection.down,
                    );
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> displayEditFoodPopup(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              label: const Text('一覧から追加する', textScaleFactor: 1.2),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                enableFeedback: false,
                              ),
                              onPressed: () {
                                audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                                Navigator.of(context).pushNamed("/addFoodPage");
                              },
                            ))),
                    Center(
                        child: SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              label: const Text('手動で追加する', textScaleFactor: 1.2),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                enableFeedback: false,
                              ),
                              onPressed: () {
                                audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                                displayManualAddFoodPopup(context);
                              },
                            ))),
                    Center(
                        child: Stack(children: <Widget>[
                      Center(
                          child: Container(
                        height: 34,
                        width: 200,
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            ' 削除する',
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      )),
                      Container(
                          height: 37,
                          width: 200,
                          margin: const EdgeInsets.only(top: 3, left: 15),
                          child: SmartSelect<String>.single(
                              title: '',
                              placeholder: '',
                              value: '',
                              onChange: (value) {
                                if (value.value != '') {
                                  for (var i = 0; i < foodList.length; i++) {
                                    if (foodList[i]['name'] == value.value) {
                                      setState(() {
                                        foodList.removeAt(i);
                                        db.rawQuery('DELETE FROM `food` WHERE `name` = "${value.value}"');
                                      });
                                      break;
                                    }
                                  }
                                  value.value = '';
                                  audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                  showSimpleNotification(
                                    const Text("削除しました！", style: TextStyle(color: Colors.white)),
                                    background: Colors.red,
                                    position: NotificationPosition.bottom,
                                    slideDismissDirection: DismissDirection.down,
                                  );
                                }
                              },
                              choiceItems: S2Choice.listFrom<String, Map>(
                                source: foodList,
                                value: (index, item) => item['name'],
                                title: (index, item) => item['name'],
                                group: (index, item) => item['group'],
                              ),
                              modalType: S2ModalType.fullPage,
                              choiceGrouped: true,
                              modalFilter: true,
                              modalFilterAuto: true,
                              modalHeaderStyle: S2ModalHeaderStyle(
                                backgroundColor: Colors.grey[850],
                                textStyle: const TextStyle(color: Colors.white),
                                iconTheme: const IconThemeData(color: Colors.white),
                                actionsIconTheme: const IconThemeData(color: Colors.white),
                              ),
                              modalStyle: S2ModalStyle(backgroundColor: Colors.grey[850]),
                              choiceStyle: const S2ChoiceStyle(
                                  titleStyle: TextStyle(color: Colors.white), activeColor: Colors.white),
                              tileBuilder: (context, state) {
                                return S2Tile.fromState(
                                  state,
                                  leading: const Text(''),
                                  trailing: const Text(''),
                                );
                              })),
                    ])),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('戻る'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            );
          });
        });
  }

  Future<void> displayEditExercisePopup(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              label: const Text('一覧から追加する', textScaleFactor: 1.2),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                enableFeedback: false,
                              ),
                              onPressed: () {
                                audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                                Navigator.of(context)
                                    .pushNamed("/addExercisePage")
                                    .then((value) => Navigator.pop(context));
                              },
                            ))),
                    Center(
                        child: SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              label: const Text('手動で追加する', textScaleFactor: 1.2),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                enableFeedback: false,
                              ),
                              onPressed: () {
                                audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                                displayManualAddExercisePopup(context)
                                    .then((value) => Navigator.pop(context));
                              },
                            ))),
                    Center(
                        child: Stack(children: <Widget>[
                      Center(
                          child: Container(
                        height: 34,
                        width: 200,
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            ' 削除する',
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.white),
                          )
                        ]),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      )),
                      Container(
                          height: 37,
                          width: 200,
                          margin: const EdgeInsets.only(top: 3, left: 15),
                          child: SmartSelect<String>.single(
                              title: '',
                              placeholder: '',
                              value: '',
                              onChange: (value) {
                                if (value.value != '') {
                                  for (var i = 0; i < exerciseList.length; i++) {
                                    if (exerciseList[i]['name'] == value.value) {
                                      setState(() {
                                        exerciseList.removeAt(i);
                                        db.rawQuery('DELETE FROM `exercise` WHERE `name` = "${value.value}"');
                                      });
                                      break;
                                    }
                                  }
                                  value.value = '';
                                  audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                  showSimpleNotification(
                                    const Text("削除しました！", style: TextStyle(color: Colors.white)),
                                    background: Colors.red,
                                    position: NotificationPosition.bottom,
                                    slideDismissDirection: DismissDirection.down,
                                  );
                                }
                              },
                              choiceItems: S2Choice.listFrom<String, Map>(
                                source: exerciseList,
                                value: (index, item) => item['name'],
                                title: (index, item) => item['name'],
                                group: (index, item) => item['group'],
                              ),
                              modalType: S2ModalType.fullPage,
                              choiceGrouped: true,
                              modalFilter: true,
                              modalFilterAuto: true,
                              modalHeaderStyle: S2ModalHeaderStyle(
                                backgroundColor: Colors.grey[850],
                                textStyle: const TextStyle(color: Colors.white),
                                iconTheme: const IconThemeData(color: Colors.white),
                                actionsIconTheme: const IconThemeData(color: Colors.white),
                              ),
                              modalStyle: S2ModalStyle(backgroundColor: Colors.grey[850]),
                              choiceStyle: const S2ChoiceStyle(
                                  titleStyle: TextStyle(color: Colors.white), activeColor: Colors.white),
                              tileBuilder: (context, state) {
                                return S2Tile.fromState(
                                  state,
                                  leading: const Text(''),
                                  trailing: const Text(''),
                                );
                              })),
                    ])),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('戻る'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            );
          });
        });
  }

  Future<void> displayManualAddFoodPopup(BuildContext context) async {
    String _food = '';
    double _calorie = 0;
    double _protein = 0;
    double _fat = 0;
    double _carb = 0;
    int? selectedIndex2 = 0;
    String _group = foodGroupCandidate[selectedIndex2];
    List<Widget> buildItems() {
      return foodGroupCandidate.map((val) => MySelectionItem(title: val)).toList();
    }

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    const Text('食品名'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              initialValue: '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _food = value;
                              },
                              decoration: InputDecoration(
                                // fillColor: Colors.green[100],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('カロリー/100g'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _calorie.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _calorie = double.parse(value);
                              },
                              decoration: InputDecoration(
                                suffix: const Text('[kcal]'),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('タンパク質の含有量/100g'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _protein.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _protein = double.parse(value);
                              },
                              decoration: InputDecoration(
                                suffix: const Text('[g]'),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('脂質の含有量/100g'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _fat.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _fat = double.parse(value);
                              },
                              decoration: InputDecoration(
                                suffix: const Text('[g]'),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('炭水化物の含有量/100g'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _carb.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _carb = double.parse(value);
                              },
                              decoration: InputDecoration(
                                suffix: const Text('[g]'),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('分類'),
                    Container(
                        alignment: Alignment.center,
                        //width: 180,
                        //height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(top: 10),
                        child: DirectSelect(
                          itemExtent: 35.0,
                          selectedIndex: selectedIndex2!,
                          child: MySelectionItem(
                            isForList: true,
                            title: foodGroupCandidate[selectedIndex2!],
                          ),
                          onSelectedItemChanged: (index) {
                            _group = foodGroupCandidate[index!];
                            setState(() {
                              selectedIndex2 = index;
                            });
                          },
                          mode: DirectSelectMode.tap,
                          items: buildItems(),
                          backgroundColor: Colors.black,
                          selectionColor: Colors.white12,
                        )),
                  ])),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false, // タッチ音をオフ
                  ),
                  child: const Text('保存'),
                  onPressed: () {
                    bool yes = true;
                    for (var i in foodList) {
                      if (i['name'] == _food) yes = false;
                    }
                    if (yes) {
                      setState(() {
                        foodList.add({
                          'used_time': "0",
                          'name': _food.toString(),
                          'group': _group.toString(),
                          'calorie': _calorie.toString(),
                          'protein': _protein.toString(),
                          'fat': _fat.toString(),
                          'carb': _carb.toString()
                        });
                        db.rawQuery(
                            'INSERT INTO `food` (`name`, `group`, `used_time`, `calorie`, `protein`, `fat`, `carb`) SELECT "$_food", "$_group", "0", "$_calorie", "$_protein", "$_fat", "$_carb"');
                      });
                      audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                      showSimpleNotification(
                        const Text("保存しました！", style: TextStyle(color: Colors.white)),
                        background: Colors.green,
                        position: NotificationPosition.bottom,
                        slideDismissDirection: DismissDirection.down,
                      );
                    } else {
                      showSimpleNotification(
                        const Text("既に保存済みです！", style: TextStyle(color: Colors.white)),
                        background: Colors.red,
                        position: NotificationPosition.bottom,
                        slideDismissDirection: DismissDirection.down,
                      );
                    }
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> displayManualAddExercisePopup(BuildContext context) async {
    String _exercise = '';
    int? selectedIndex2 = 0;
    String _group = exerciseGroupCandidate[selectedIndex2];
    List<Widget> buildItems() {
      return exerciseGroupCandidate.map((val) => MySelectionItem(title: val)).toList();
    }

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('種目名'),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            //width: 180,
                            //height: 30,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              initialValue: '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              onChanged: (value) {
                                _exercise = value;
                              },
                              decoration: InputDecoration(
                                hintText: "入力して下さい",
                                // fillColor: Colors.green[100],
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ))),
                    const Text('分類'),
                    Container(
                        alignment: Alignment.center,
                        //width: 180,
                        //height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(top: 10),
                        child: DirectSelect(
                          itemExtent: 35.0,
                          selectedIndex: selectedIndex2!,
                          child: MySelectionItem(
                            isForList: true,
                            title: exerciseGroupCandidate[selectedIndex2!],
                          ),
                          onSelectedItemChanged: (index) {
                            _group = exerciseGroupCandidate[index!];
                            setState(() {
                              selectedIndex2 = index;
                            });
                          },
                          mode: DirectSelectMode.tap,
                          items: buildItems(),
                          backgroundColor: Colors.black,
                          selectionColor: Colors.white12,
                        )),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false,
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    audioPlayer.play('navigation_backward-selection.wav', volume: volume);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // 背景
                    onPrimary: Colors.white, // 文字色
                    enableFeedback: false, // タッチ音をオフ
                  ),
                  child: const Text('保存'),
                  onPressed: () {
                    bool yes = true;
                    for (var i in exerciseList) {
                      if (i['name'] == _exercise) yes = false;
                    }
                    if (yes) {
                      setState(() {
                        exerciseList.add({'used_time': 0, 'name': _exercise, 'group': _group});
                        db.rawQuery(
                            'INSERT INTO `exercise` (`name`, `group`, `used_time`) SELECT "$_exercise", "$_group", "0"');
                      });
                      audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                      showSimpleNotification(
                        const Text("保存しました！", style: TextStyle(color: Colors.white)),
                        background: Colors.green,
                        position: NotificationPosition.bottom,
                        slideDismissDirection: DismissDirection.down,
                      );
                    } else {
                      showSimpleNotification(
                        const Text("既に保存済みです！", style: TextStyle(color: Colors.white)),
                        background: Colors.red,
                        position: NotificationPosition.bottom,
                        slideDismissDirection: DismissDirection.down,
                      );
                    }
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
        });
  }
}
