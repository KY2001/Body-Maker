import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smart_select/smart_select.dart';
import 'package:training_app/data.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  List<Widget> children = [const SizedBox(height: 7)];

  @override
  Widget build(BuildContext context) {
    for (var i in foodGroupCandidate) {
      children.add(SmartSelect<String>.single(
          title: i,
          placeholder: '',
          value: '',
          onChange: (value) {
            if (value.value != '') {
              bool yes = true;
              for (var j in foodList) {
                if (j['name'] == value.value) yes = false;
              }
              if (yes) {
                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                showSimpleNotification(
                  const Text("追加しました！", style: TextStyle(color: Colors.white)),
                  background: Colors.green,
                  position: NotificationPosition.bottom,
                  slideDismissDirection: DismissDirection.down,
                );
                foodSearchList[i]?.forEach((element) {
                  if (element['name'] == value.value) {
                    setState(() {
                      foodList.add({
                        'used_time': 0,
                        'name': value.value,
                        'calorie': element['calorie'],
                        'protein': element['protein'],
                        'fat': element['fat'],
                        'carb': element['carb'],
                        'group': i
                      });
                      db.rawQuery(
                          'INSERT INTO `food` (`name`, `calorie`, `protein`, `fat`, `carb`, `group`, `used_time`) SELECT "${value.value}", "${element['calorie']}", "${element['protein']}", "${element['fat']}", "${element['carb']}","${element['group']}", "0"');
                    });
                  }
                });
              } else {
                showSimpleNotification(
                  const Text("この食品は既に追加済みです！", style: TextStyle(color: Colors.white)),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                  slideDismissDirection: DismissDirection.down,
                );
              }
              value.value = "";
            }
          },
          choiceItems: S2Choice.listFrom<String, Map>(
            source: foodSearchList[i],
            value: (index, item) => item['name'],
            title: (index, item) => item['name'],
            group: (index, item) => i,
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
          choiceStyle:
              const S2ChoiceStyle(titleStyle: TextStyle(color: Colors.white), activeColor: Colors.white),
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              leading: const Icon(Icons.search),
            );
          }));
      children.add(const Divider(indent: 20));
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          Icon(Icons.edit),
          Text(
            "食品の編集",
            textScaleFactor: 1.1,
          ),
        ]),
      ),
      body: SingleChildScrollView(child: Column(children: children)),
    );
  }
}
