import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/shirt.dart';

class PlayerListItem extends StatelessWidget {
  final Player player;
  final Function(Player) onTap;

  const PlayerListItem({Key? key, required this.player, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Shirt(size: 45, player: player, showNumber: true),
            Padding(padding: const EdgeInsets.only(left: 20.0)),
            Text(player.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200)),
          ],
        ),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(player), 
    );
  }
}
