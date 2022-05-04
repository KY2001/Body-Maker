import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smart_select/smart_select.dart';
import 'package:training_app/data.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  List<Widget> children = [const SizedBox(height: 7)];

  @override
  Widget build(BuildContext context) {
    for (var i in [
      ['chest', '胸'],
      ['shoulder', '肩'],
      ['back', '背中'],
      ['biceps', '上腕二頭筋'],
      ['triceps', '上腕三頭筋'],
      ['leg', '脚'],
      ['forearm', '前腕'],
      ['full', '全身'],
    ]) {
      children.add(SmartSelect<String>.single(
          title: '${i[1]}の種目',
          placeholder: '',
          value: '',
          onChange: (value) {
            if (value.value != '') {
              bool yes = true;
              for (var i in exerciseList) {
                if (i['name'] == value.value) yes = false;
              }
              if (yes) {
                audioPlayer.play('hero_simple-celebration-01.wav', volume: volume);
                showSimpleNotification(
                  const Text("追加しました！", style: TextStyle(color: Colors.white)),
                  background: Colors.green,
                  position: NotificationPosition.bottom,
                  slideDismissDirection: DismissDirection.down,
                );
                exerciseSearchList[i[0]]?.forEach((element) {
                  if (element['name'] == value.value) {
                    setState(() {
                      exerciseList.add({'used_time': 0, 'name': value.value, 'group': element['group']});
                      db.rawQuery(
                          'INSERT INTO `exercise` (`name`, `group`, `used_time`) SELECT "${value.value}", "${element['group']}", "0"');
                    });
                  }
                });
              } else {
                showSimpleNotification(
                  const Text("この種目は既に追加済みです！", style: TextStyle(color: Colors.white)),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                  slideDismissDirection: DismissDirection.down,
                );
              }
              value.value = "";
            }
          },
          choiceItems: S2Choice.listFrom<String, Map>(
            source: exerciseSearchList[i[0]],
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
            " 種目の編集",
            textScaleFactor: 1.1,
          ),
        ]),
      ),
      body: Column(children: children),
    );
  }
}
