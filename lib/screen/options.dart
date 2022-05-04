import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../module.dart';
import 'package:training_app/data.dart';

class OptionalPage extends StatefulWidget {
  // コンストラクタ, MainPageを呼び出す際の引数などを定める。
  const OptionalPage({Key? key}) : super(key: key);

  @override
  State<OptionalPage> createState() => _OptionalPageState(); // _MyHomePageStateというステートを作成。
}

class _OptionalPageState extends State<OptionalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // widget.title: 受け取ったtitleを表示
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          Icon(Icons.settings),
          Text(" 設定", textScaleFactor: 1.1),
        ])),
        body: Container(
          alignment: Alignment.center,
          color: Colors.black12,
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                Text('音量: ${(volume * 100).toInt()}', textScaleFactor: 1.2),
                Slider(
                  value: volume * 100,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: (volume * 100).toInt().toString(),
                  onChanged: (value) {
                    db.rawQuery('UPDATE `options` SET `volume` = "${value / 100}"');
                    setState(() {
                      volume = value / 100;
                    });
                  },
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('最大重量:', textScaleFactor: 1.2),
                      const Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: 180,
                          height: 30,
                          // padding: const EdgeInsets.only(top: 11.0),
                          margin: const EdgeInsets.only(left: 20, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: maxWeight.toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onFieldSubmitted: (value) {
                              if (double.tryParse(value) != null && double.parse(value) > minWeight) {
                                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                showSimpleNotification(
                                  const Text("変更を保存しました！", style: TextStyle(color: Colors.white)),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                                db.rawQuery('UPDATE `options` SET `maxWeight` = "$value"');
                                setState(() {
                                  maxWeight = double.parse(value);
                                  if (weight > maxWeight) weight = minWeight;
                                });
                              } else {
                                showSimpleNotification(
                                  const Text("有効な値を入力して下さい！", style: TextStyle(color: Colors.white)),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              // fillColor: Colors.green[100],
                              suffix: const Text('[kg]'),
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
                          )),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('最小重量:', textScaleFactor: 1.2),
                      const Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: 180,
                          height: 30,
                          // padding: const EdgeInsets.only(top: 11.0),
                          margin: const EdgeInsets.only(left: 20, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: minWeight.toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onFieldSubmitted: (value) {
                              if (double.tryParse(value) != null && double.parse(value) < maxWeight) {
                                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                showSimpleNotification(
                                  const Text("変更を保存しました！", style: TextStyle(color: Colors.white)),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                                db.rawQuery('UPDATE `options` SET `minWeight` = "$value"');
                                setState(() {
                                  minWeight = double.parse(value);
                                  if (weight < minWeight) weight = minWeight;
                                });
                              } else {
                                showSimpleNotification(
                                  const Text("有効な値を入力して下さい！", style: TextStyle(color: Colors.white)),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              // fillColor: Colors.green[100],
                              suffix: const Text('[kg]'),
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
                          )),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('重量の間隔:', textScaleFactor: 1.2),
                      const Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: 180,
                          height: 30,
                          // padding: const EdgeInsets.only(top: 11.0),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: intervalWeight.toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onFieldSubmitted: (value) {
                              if (double.tryParse(value) != null &&
                                  double.parse(value) <= (maxWeight - minWeight)) {
                                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                showSimpleNotification(
                                  const Text("変更を保存しました！", style: TextStyle(color: Colors.white)),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                                db.rawQuery('UPDATE `options` SET `intervalWeight` = "$value"');
                                setState(() {
                                  intervalWeight = double.parse(value);
                                  weight = minWeight;
                                });
                              } else {
                                showSimpleNotification(
                                  const Text("有効な値を入力して下さい！", style: TextStyle(color: Colors.white)),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              // fillColor: Colors.green[100],
                              suffix: const Text('[kg]'),
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
                          )),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('最大レップ数:', textScaleFactor: 1.2),
                      const Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: 180,
                          height: 30,
                          // padding: const EdgeInsets.only(top: 11.0),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: maxRep.toInt().toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onFieldSubmitted: (value) {
                              if (int.tryParse(value) != null && int.parse(value) > minRep) {
                                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                showSimpleNotification(
                                  const Text("変更を保存しました！", style: TextStyle(color: Colors.white)),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                                db.rawQuery('UPDATE `options` SET `maxRep` = "$value"');
                                setState(() {
                                  maxRep = double.parse(value);
                                  if (rep > maxRep) rep = minRep.toInt();
                                });
                              } else {
                                showSimpleNotification(
                                  const Text("有効な値を入力して下さい！", style: TextStyle(color: Colors.white)),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              // fillColor: Colors.green[100],
                              suffix: const Text('[rep]'),
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
                          )),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('最大セット数:', textScaleFactor: 1.2),
                      const Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: 180,
                          height: 30,
                          // padding: const EdgeInsets.only(top: 11.0),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: maxSet.toInt().toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onFieldSubmitted: (value) {
                              if (int.tryParse(value) != null && int.parse(value) > minSet) {
                                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                                showSimpleNotification(
                                  const Text("変更を保存しました！", style: TextStyle(color: Colors.white)),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                                db.rawQuery('UPDATE `options` SET `maxSet` = "$value"');
                                setState(() {
                                  maxSet = double.parse(value);
                                  if (set > maxSet) set = minSet.toInt();
                                });
                              } else {
                                showSimpleNotification(
                                  const Text("有効な値を入力して下さい！", style: TextStyle(color: Colors.white)),
                                  background: Colors.red,
                                  position: NotificationPosition.bottom,
                                  slideDismissDirection: DismissDirection.down,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              // fillColor: Colors.green[100],
                              suffix: const Text('[set]'),
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
                          )),
                    ]),
              ])),
        ));
  }
}
