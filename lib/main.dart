import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'screen/main_page.dart';
import 'screen/options.dart';
import 'screen/add_exercise.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

// extends: MyappがStatelessWidgetを継承する。
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override //@override: 継承したStatelessWidgetのbuildを一部だけ上書きする。
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'トレメモ',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'NotoSansJP',
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const MainPage(),
      // ホーム画面を指定
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const MainPage(),
        '/optionalPage': (BuildContext context) => const OptionalPage(),
        '/addExercisePage': (BuildContext context) => const AddExercisePage(),
      },
    ));
  }
}
