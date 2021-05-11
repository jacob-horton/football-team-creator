import 'package:flutter/material.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/widgets/player_editor.dart';
import 'package:football/widgets/player_searcher.dart';

class PlayerSelector extends StatelessWidget {
  final bool multiselect;

  PlayerSelector({Key? key, required this.multiselect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Row(
        children: [
          Flexible(
            child: PlayerSearcher(
              onOk: () => Navigation.pop(context),
              onCancel: () => Navigation.pop(context),
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
}