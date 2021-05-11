import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/pages/team_editor.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/widgets/formation_dropdown.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:football/widgets/rounded_container.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final List<List<int>> formations = [
    [4, 4, 2],
    [3, 5, 2]
  ];

  //final List<Player> players = [
  //  Player(name: 'Jacob Horton', number: 1, score: 10, colour: 'red'),
  //  Player(name: 'Daniel Kingshott', number: 5, score: 1, colour: 'orange'),
  //];

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4eb85c),
      body: Stack(
        children: [
          // Background
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset('assets/background.png'),
            ),
          ),
          // Players
          StreamBuilder<List<Player>>(
            stream: Provider.of<AppDatabase>(context, listen: false).watchAllPLayers(),
            builder: (context, snapshot) {
              final players = snapshot.data ?? [];

              // TODO: Create and keep track of list of current players
              return Stack(children: players.map((player) => PlayerDraggable(player: player)).toList());
            }
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                FormationDropdown(formations: formations),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                _buildChangePlayersButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePlayersButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.navigateTo(context, TeamEditor()),
      child: RoundedContainer(
        colour: const Color(0xff71c67d),
        child: Center(
          child: Text(
            'CHANGE PLAYERS',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
