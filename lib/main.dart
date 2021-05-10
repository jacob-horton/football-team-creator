import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/utils/window_resize.dart';
import 'package:window_size/window_size.dart';

import 'bloc/formation_bloc.dart';
import 'pages/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowResize.setWidthMaintainAspect(1000, fixedSize: true);
    setWindowTitle('Team creator');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormationBloc(),
      child: MaterialApp(
        title: 'Football',
        home: MainPage(),
      ),
    );
  }
}
