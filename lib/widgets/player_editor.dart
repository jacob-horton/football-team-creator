import 'package:flutter/material.dart';

class PlayerEditor extends StatelessWidget {
  const PlayerEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Player not selected', style: Theme.of(context).textTheme.caption));
  }
}
