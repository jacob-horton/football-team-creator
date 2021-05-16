import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/utils/window_resize.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'bloc/formation/formation_bloc.dart';
import 'pages/main_page.dart';

final appName = 'Football Team Creator';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowResize.setWidthMaintainAspect(1000, fixedSize: true);
    setWindowTitle(appName);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const textStyle = TextStyle(
    letterSpacing: 0.8,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    return MultiProvider(
      providers: [
        Provider(create: (_) => db.playerDao),
      ],
      child: BlocProvider(
        create: (context) => FormationBloc(dao: db.currentPlayerDao),
        child: MaterialApp(
          title: appName,
          theme: ThemeData(
            fontFamily: 'Arial',
            textTheme: TextTheme(
              bodyText1: textStyle,
              subtitle1: textStyle,
              caption: TextStyle(
                fontSize: 16,
                color: const Color(0xffb0b0b0),
              ),
            ),
          ),
          home: MainPage(),
        ),
      ),
    );
  }
}
