import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setWindowSize(const Size(800, 512));
    DesktopWindow.setMinWindowSize(const Size(600, 450));
    setWindowTitle('Team creator');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football',
      home: Scaffold(
        backgroundColor: const Color(0xff4eb85c),
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset('assets/background.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xff71c67d),
                    ),
                    height: 28.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: 1,
                        dropdownColor: const Color(0xff333333),
                        items: [
                          DropdownMenuItem(child: Text('4 - 4 - 2', style: TextStyle(color: Colors.white)), value: 1),
                          DropdownMenuItem(child: Text('3 - 5 - 2', style: TextStyle(color: Colors.white)), value: 2),
                          DropdownMenuItem(child: Text('Custom', style: TextStyle(color: Colors.white)), value: 3),
                        ],
                        onChanged: (a) {},
                        iconEnabledColor: Colors.white,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff71c67d),
                      ),
                    ),
                    onPressed: () => print('test'),
                    child: Container(
                      height: 25.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(child: Text('CHANGE PLAYERS', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w400))),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                PlayerDraggable(),
                PlayerDraggable(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
