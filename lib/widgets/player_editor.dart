import 'package:flutter/material.dart';

class PlayerEditor extends StatelessWidget {
  const PlayerEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Make colours global constants
    return Center(child: Text('Player not selected', style: TextStyle(color: const Color(0xffb0b0b0))));
  }
}
