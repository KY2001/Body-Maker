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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
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
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => const MainPage(),
            '/optionalPage': (BuildContext context) => const OptionalPage(),
            '/addExercisePage': (BuildContext context) => const AddExercisePage(),
          },
        ));
  }
}
