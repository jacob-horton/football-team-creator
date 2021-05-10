import 'package:flutter/material.dart';
import 'package:football/utils/window_resize.dart';
import 'package:window_size/window_size.dart';

class PlayerSelector extends StatelessWidget {
  const PlayerSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: TextButton(
          onPressed: () => _navigateToMainPage(context),
          child: Text('Back'),
        ),
      ),
    );
  }
  
  _navigateToMainPage(BuildContext context) {
    setWindowTitle('Team Creator');
    WindowResize.setWidthMaintainAspect(1000, fixedSize: true);
    Navigator.of(context).pop();
  }
}
