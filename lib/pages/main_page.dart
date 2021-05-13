import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/pages/team_editor.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/widgets/formation_dropdown.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:football/widgets/rounded_container.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

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
          PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              StreamBuilder<List<PlayerWithPosition>>(
                stream: Provider.of<CurrentPlayerDao>(context).watchAllPlayers(),
                builder: (context, snapshot) {
                  final players = snapshot.data ?? [];

                  return Stack(
                    children: [
                      Stack(
                        children: players.map((player) => PlayerDraggable(playerWithPosition: player)).toList(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: Text('Team 1 >'),
                          onTap: () => controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.ease),
                        ),
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<List<PlayerWithPosition>>(
                stream: Provider.of<CurrentPlayerDao>(context, listen: false).watchAllPlayers(),
                builder: (context, snapshot) {
                  final players = snapshot.data ?? [];

                  return Stack(
                    children: [
                      Stack(
                        children: players.map((player) => PlayerDraggable(playerWithPosition: player)).toList(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: Text('< Team 2'),
                          onTap: () => controller.previousPage(duration: Duration(milliseconds: 200), curve: Curves.ease),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                FormationDropdown(
                  formations: formations,
                  onFormationSelected: (formation) async {
                    final dao = Provider.of<CurrentPlayerDao>(context, listen: false);
                    final players = await dao.getAllPlayers();

                    const double border = 50;
                    Offset windowSize = (MediaQuery.of(context).size - Size(border * 2, border * 2)) as Offset;
                    final horizontalSpacing = windowSize.dx / formation.length.toDouble();
                    for (int i = 0; i < formation.length; i++) {
                      final verticalSpacing = windowSize.dy / formation[i].toDouble();
                      for (int j = 0; j < formation[i]; j++) {
                        //TODO: Get random player with correct preferred position
                        final player = players[0];
                        players.removeAt(0);

                        dao.updatePlayer(
                          player.position.copyWith(
                            x: horizontalSpacing * i + horizontalSpacing / 2 - PlayerDraggable.size / 2 + border,
                            y: verticalSpacing * j + verticalSpacing / 2 - PlayerDraggable.size / 2 + border,
                          ),
                        );
                      }
                    }
                  },
                ),
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
