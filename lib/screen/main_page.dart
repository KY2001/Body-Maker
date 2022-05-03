import 'dart:math';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../module.dart';
import 'options.dart';
import 'add_exercise.dart';

// stateful: 見た目の変化や値の変化を伴う。
class MainPage extends StatefulWidget {
  // コンストラクタ, MainPageを呼び出す際の引数などを定める。
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState(); // _MyHomePageStateというステートを作成。
}

// extends State<MyHomePage>: MyHomePageのStateの一つですよみたいなイメージ。
class _MainPageState extends State<MainPage> {
  Future<void> updateData() async {
    List<TableRow> _recordsTodayTable = [
      const TableRow(children: [
        Center(child: Text('  時間  ', textScaleFactor: 1.2)),
        Center(child: Text(' 種目 ', textScaleFactor: 1.2)),
        Center(child: Text(' 重量 ', textScaleFactor: 1.2)),
        Center(child: Text(' 回数 ', textScaleFactor: 1.2)),
        Center(child: Text(' セット数 ', textScaleFactor: 1.2)),
      ])
    ];

    List<Map> recordsToday = await db.rawQuery('SELECT * FROM `record`');
    for (var i in recordsToday) {
      List<Widget> children = [
        Center(child: Text(' ${timeDisAssemble(i["time"])['hour:minute']} ', textScaleFactor: 1.1)),
        Center(child: Text(' ${i["exercise"]} ', textScaleFactor: 1.1)),
        Center(child: Text(' ${i["weight"]} ', textScaleFactor: 1.1)),
        Center(child: Text(' ${i["rep"]} ', textScaleFactor: 1.1)),
        Center(child: Text(' ${i["set"]} ', textScaleFactor: 1.1)),
      ];
      _recordsTodayTable.add(TableRow(
        children: children,
      ));
    }
    setState(() {
      recordsTodayTable = _recordsTodayTable;
    });
    scoreToday = 0;
    for (var i in recordsToday) {
      scoreToday += (double.parse(i['weight'].toString()) *
          double.parse(i['rep'].toString()) *
          double.parse(i['set'].toString()));
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController(text: exercise);
    void showPicker() {
      final _pickerItems = exerciseList.map((item) => Text(item)).toList();
      var selectedIndex = 0;
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 216,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                  ),
                  child: CupertinoPicker(
                    itemExtent: 32,
                    children: _pickerItems,
                    onSelectedItemChanged: (int index) {
                      selectedIndex = index;
                    },
                  )),
            ),
          );
        },
      ).then((_) {
        controller.value = TextEditingValue(text: exerciseList[selectedIndex]);
        print(controller.text);
        setState(() {
          exercise = controller.text;
        });
      });
    }

    int? selectedIndex = 0;
    List<Widget> buildItems() {
      return exerciseList.map((val) => MySelectionItem(title: val)).toList();
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
                    const Text('種目'),
                    DirectSelect(
                      itemExtent: 35.0,
                      selectedIndex: selectedIndex!,
                      child: MySelectionItem(
                        isForList: true,
                        title: exerciseList[selectedIndex!],
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      mode: DirectSelectMode.tap,
                      items: buildItems(),
                      backgroundColor: Colors.black,
                      selectionColor: Colors.white12,
                    ),
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
                        'INSERT INTO `record` (`time`, `exercise`, `weight`, `rep`, `set`) VALUES("$now", "$exercise", "$weight", "$rep", "$set")');
                    updateData();
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

// setState()はこのStateの中でなにか変更が起きたことを知らせ、ビルドを再実行し、値の更新を反映する。

  @override
  void initState() {
    //アプリ起動時に一度だけ実行される
    super.initState();
    Future(() async {
      await getDatabase();
      await initDatabase();
      await updateData();
    });
  }

  // setstate()が呼ばれるたびに実行される。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.fitness_center),
              const Text("トレーニングメモ", textScaleFactor: 1.1),
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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("本日の記録", textScaleFactor: 1.2),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: Table(
                    border: TableBorder.all(color: Colors.black),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: recordsTodayTable),
              ),
              Text("スコア: ${scoreToday.toInt()} [kg・rep・set]", textScaleFactor: 1.3),
            ]),
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                width: 150,
                height: 90,
                child: FloatingActionButton.extended(
                  heroTag: "hero1",
                  onPressed: () {
                    audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                    Navigator.of(context).pushNamed("/addExercisePage");
                  },
                  enableFeedback: false,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  isExtended: true,
                  label: const Text(
                    '種目の追加',
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
                audioPlayer.play('ui_tap-variant-01.wav', volume: volume);
                _displayTextInputDialog(context);
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
        ]));
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
