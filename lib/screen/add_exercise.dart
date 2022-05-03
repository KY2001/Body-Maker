import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter/widgets.dart';

List<Map<String, dynamic>> cars = [
  {'value': 'bmw-x1', 'title': 'BMW X1', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x7', 'title': 'BMW X7', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x2', 'title': 'BMW X2', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x4', 'title': 'BMW X4', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'honda-crv', 'title': 'Honda C-RV', 'brand': 'Honda', 'body': 'SUV'},
  {'value': 'honda-hrv', 'title': 'Honda H-RV', 'brand': 'Honda', 'body': 'SUV'},
  {'value': 'mercedes-gcl', 'title': 'Mercedes-Benz G-class', 'brand': 'Mercedes', 'body': 'SUV'},
  {'value': 'mercedes-gle', 'title': 'Mercedes-Benz GLE', 'brand': 'Mercedes', 'body': 'SUV'},
  {'value': 'mercedes-ecq', 'title': 'Mercedes-Benz ECQ', 'brand': 'Mercedes', 'body': 'SUV'},
  {'value': 'mercedes-glcc', 'title': 'Mercedes-Benz GLC Coupe', 'brand': 'Mercedes', 'body': 'SUV'},
  {'value': 'lr-ds', 'title': 'Land Rover Discovery Sport', 'brand': 'Land Rover', 'body': 'SUV'},
  {'value': 'lr-rre', 'title': 'Land Rover Range Rover Evoque', 'brand': 'Land Rover', 'body': 'SUV'},
  {'value': 'honda-jazz', 'title': 'Honda Jazz', 'brand': 'Honda', 'body': 'Hatchback'},
  {'value': 'honda-civic', 'title': 'Honda Civic', 'brand': 'Honda', 'body': 'Hatchback'},
  {'value': 'mercedes-ac', 'title': 'Mercedes-Benz A-class', 'brand': 'Mercedes', 'body': 'Hatchback'},
  {'value': 'hyundai-i30f', 'title': 'Hyundai i30 Fastback', 'brand': 'Hyundai', 'body': 'Hatchback'},
  {'value': 'hyundai-kona', 'title': 'Hyundai Kona Electric', 'brand': 'Hyundai', 'body': 'Hatchback'},
  {'value': 'hyundai-i10', 'title': 'Hyundai i10', 'brand': 'Hyundai', 'body': 'Hatchback'},
  {'value': 'bmw-i3', 'title': 'BMW i3', 'brand': 'BMW', 'body': 'Hatchback'},
  {'value': 'bmw-sgc', 'title': 'BMW 4-serie Gran Coupe', 'brand': 'BMW', 'body': 'Hatchback'},
  {'value': 'bmw-sgt', 'title': 'BMW 6-serie GT', 'brand': 'BMW', 'body': 'Hatchback'},
  {'value': 'audi-a5s', 'title': 'Audi A5 Sportback', 'brand': 'Audi', 'body': 'Hatchback'},
  {'value': 'audi-rs3s', 'title': 'Audi RS3 Sportback', 'brand': 'Audi', 'body': 'Hatchback'},
  {'value': 'audi-ttc', 'title': 'Audi TT Coupe', 'brand': 'Audi', 'body': 'Coupe'},
  {'value': 'audi-r8c', 'title': 'Audi R8 Coupe', 'brand': 'Audi', 'body': 'Coupe'},
  {'value': 'mclaren-570gt', 'title': 'Mclaren 570GT', 'brand': 'Mclaren', 'body': 'Coupe'},
  {'value': 'mclaren-570s', 'title': 'Mclaren 570S Spider', 'brand': 'Mclaren', 'body': 'Coupe'},
  {'value': 'mclaren-720s', 'title': 'Mclaren 720S', 'brand': 'Mclaren', 'body': 'Coupe'},
];

List<Map<String, dynamic>> chestExerciseSearchList = [
  {'name': 'ベンチプレス', 'group': 'フリーウェイト(胸)'},
  {'name': 'インクラインベンチプレス', 'group': 'フリーウェイト(胸)'},
  {'name': 'デクラインベンチプレス', 'group': 'フリーウェイト(胸)'},
  {'name': 'ベントアームプルオーバー', 'group': 'フリーウェイト(胸)'},
  {'name': 'ダンベルフライ', 'group': 'フリーウェイト(胸)'},
  {'name': 'インクラインダンベルベンチプレス', 'group': 'フリーウェイト(胸)'},
  {'name': 'ダンベルベンチプレス', 'group': 'フリーウェイト(胸)'},
  {'name': 'ダンベルプルオーバー', 'group': 'フリーウェイト(胸)'},
  {'name': 'バタフライマシン', 'group': 'マシン(胸)'},
  {'name': 'ケーブルクロスオーバー', 'group': 'マシン(胸)'},
  {'name': 'プッシュアップ（腕立て伏せ）', 'group': '自重(胸)'},
  {'name': 'ディップス（ディッピング）', 'group': '自重(胸)'},
];
List<Map<String, dynamic>> shoulderExerciseSearchList = [
  {'name': 'スタンディングロー', 'group': 'フリーウェイト(肩)'},
  {'name': 'バックプレス', 'group': 'フリーウェイト(肩)'},
  {'name': 'フロントプレス', 'group': 'フリーウェイト(肩)'},
  {'name': 'バーベルシュラッグ', 'group': 'フリーウェイト(肩)'},
  {'name': 'ベントオーバーフロントプルアップ', 'group': 'フリーウェイト(肩)'},
  {'name': 'プルアップトゥチェスト', 'group': 'フリーウェイト(肩)'},
  {'name': 'サイドレイズ', 'group': 'フリーウェイト(肩)'},
  {'name': 'ダンベルプレス', 'group': 'フリーウェイト(肩)'},
  {'name': 'ベントオーバーラテラル', 'group': 'フリーウェイト(肩)'},
  {'name': 'フロントレイズ', 'group': 'フリーウェイト(肩)'},
  {'name': 'ダンベルシュラッグ', 'group': 'フリーウェイト(肩)'},
  {'name': 'ワンハンドラテラル', 'group': 'フリーウェイト(肩)'},
  {'name': 'ケーブルサイドレイズ', 'group': 'マシン(肩)'},
  {'name': 'ケーブルフロントレイズ', 'group': 'マシン(肩)'},
  {'name': 'ハンドスタンドプッシュアップ（逆立ち腕立て伏せ）', 'group': '自重(肩)'},
];
List<Map<String, dynamic>> backExerciseSearchList = [
  {'name': 'ベントオーバーロー', 'group': 'フリーウェイト(背中)'},
  {'name': 'デッドリフト', 'group': 'フリーウェイト(背中)'},
  {'name': 'バックエクステンション', 'group': 'フリーウェイト(背中)'},
  {'name': 'グッドモーニング(ベンドオーバー）', 'group': 'フリーウェイト(背中)'},
  {'name': 'ベントアームプルオーバー', 'group': 'フリーウェイト(背中)'},
  {'name': 'ダンベルプルオーバー', 'group': 'フリーウェイト(背中)'},
  {'name': 'ワンハンドローイング', 'group': 'フリーウェイト(背中)'},
  {'name': 'ラットプルダウン', 'group': 'マシン(背中)'},
  {'name': 'シーテッドプーリーロー', 'group': 'マシン(背中)'},
  {'name': 'チンニング（懸垂）', 'group': '自重(背中)'},
];
List<Map<String, dynamic>> tricepsExerciseSearchList = [
  {'name': 'フレンチプレス', 'group': 'フリーウェイト(上腕三頭筋)'},
  {'name': 'トライセプスエクステンション', 'group': 'フリーウェイト(上腕三頭筋)'},
  {'name': 'ナローグリップベンチプレス', 'group': 'フリーウェイト(上腕三頭筋)'},
  {'name': 'ワンハンドトライセプスエクステンション', 'group': 'フリーウェイト(上腕三頭筋)'},
  {'name': 'トライセプスキックバック', 'group': 'フリーウェイト(上腕三頭筋)'},
  {'name': 'ケーブルトライセプスエクステンション', 'group': 'マシン(上腕三頭筋)'},
  {'name': 'プレスダウン', 'group': 'マシン(上腕三頭筋)'},
  {'name': 'ナロープッシュアップ', 'group': '自重(上腕三頭筋)'},
  {'name': 'リバースプッシュアップ', 'group': '自重(上腕三頭筋)'},
];
List<Map<String, dynamic>> bicepsExerciseSearchList = [
  {'name': 'バーベルカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'プリーチャーズベンチカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'ダンベルカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'コンセントレーションカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'インクラインカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'ハンマーカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'ライイングダウンカール', 'group': 'フリーウェイト(上腕二頭筋)'},
  {'name': 'ケーブルカール', 'group': 'マシン(上腕二頭筋)'},
];
List<Map<String, dynamic>> absExerciseSearchList = [
  {'name': 'プローンローリング', 'group': 'フリーウェイト(腹筋)'},
  {'name': 'サイドベンド', 'group': 'フリーウェイト(腹筋)'},
  {'name': 'プレスシットアップ', 'group': 'フリーウェイト(腹筋)'},
  {'name': 'ケーブルクランチ', 'group': 'マシン(腹筋)'},
  {'name': 'ロープクランチ', 'group': 'マシン(腹筋)'},
  {'name': 'アブベンチクランチ', 'group': 'マシン(腹筋)'},
  {'name': 'ストレートレッグクランチ', 'group': '自重(腹筋)'},
  {'name': 'シットアップ', 'group': '自重(腹筋)'},
  {'name': 'クランチ', 'group': '自重(腹筋)'},
  {'name': 'ヒップレイズ', 'group': '自重(腹筋)'},
  {'name': 'レッグレイズ', 'group': '自重(腹筋)'},
  {'name': 'ハンギングレッグレイズ', 'group': '自重(腹筋)'},
  {'name': 'ボディアーチ', 'group': '自重(腹筋)'},
  {'name': 'リバースクランチ', 'group': '自重(腹筋)'},
  {'name': 'レッグレイズアンドクランチ', 'group': '自重(腹筋)'},
  {'name': 'ドラゴンフラッグ', 'group': '自重(腹筋)'},
];
List<Map<String, dynamic>> legExerciseSearchList = [
  {'name': 'フルスクワット', 'group': 'フリーウェイト(足)'},
  {'name': 'フロントランジ', 'group': 'フリーウェイト(足)'},
  {'name': 'フロントスクワット', 'group': 'フリーウェイト(足)'},
  {'name': 'ハックリフト', 'group': 'フリーウェイト(足)'},
  {'name': 'レッグプレス', 'group': 'マシン(足)'},
  {'name': 'レッグエクステンション', 'group': 'マシン(足)'},
  {'name': 'レッグカール', 'group': 'マシン(足)'},
  {'name': 'カーフレイズオンレッグプレス', 'group': 'マシン(足)'},
  {'name': 'ワンレッグスクワット', 'group': '自重(足)'},
  {'name': 'シッシースクワット', 'group': '自重(足)'},
];
List<Map<String, dynamic>> forearmExerciseSearchList = [
  {'name': 'リストカール', 'group': 'フリーウェイト(前腕)'},
];
List<Map<String, dynamic>> fullExerciseSearchList = [
  {'name': 'ハイクリーン', 'group': 'フリーウェイト(全身)'},
];

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  String _exercise = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          Icon(Icons.edit),
          Text(
            " 種目の追加",
            textScaleFactor: 1.1,
          ),
        ]),
      ),
      body: Column(children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.single(
            title: '一覧から選ぶ(胸)',
            placeholder: '',
            value: _exercise,
            onChange: (value) {
              setState(() => _exercise = value.value);
            },
            choiceItems: S2Choice.listFrom<String, Map>(
              source: chestExerciseSearchList,
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
            }),
        SmartSelect<String>.single(
            title: '一覧から選ぶ(肩)',
            placeholder: '',
            value: _exercise,
            onChange: (value) {
              setState(() => _exercise = value.value);
            },
            choiceItems: S2Choice.listFrom<String, Map>(
              source: shoulderExerciseSearchList,
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
            }),
        const Divider(indent: 20),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("手動で追加する"),
          trailing: const Icon(Icons.navigate_next, color: Colors.white38),
          onTap: () {},
        ),
      ]),
    );
  }
}
