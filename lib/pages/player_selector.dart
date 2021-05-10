import 'package:flutter/material.dart';
import 'package:football/widgets/player_editor.dart';
import 'package:football/widgets/player_searcher.dart';
import 'package:window_size/window_size.dart';

class PlayerSelector extends StatelessWidget {
  final bool multiselect;

  const PlayerSelector({Key? key, required this.multiselect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Row(
        children: [
          Flexible(
            child: PlayerSearcher(
              onOk: () => _navigateToMainPage(context),
              onCancel: () => _navigateToMainPage(context),
              multiselect: multiselect,
            ),
            flex: 3,
          ),
          VerticalDivider(width: 0, endIndent: 10, indent: 10),
          Flexible(child: PlayerEditor(), flex: 2),
        ],
      ),
    );
  }

  _navigateToMainPage(BuildContext context) {
    setWindowTitle('Team Creator');
    Navigator.of(context).pop();
  }
}