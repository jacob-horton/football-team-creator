import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_team/current_team_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/pages/team_editor.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/widgets/formation_dropdown.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:football/widgets/rounded_container.dart';

class MainPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  final List<List<int>> formations = [
    [1, 3, 3, 2, 1],
    [1, 3, 4, 2],
    [1, 4, 4, 1],
    [1, 3, 3, 3],
    [1, 5, 4],
    [3, 5, 2],
    [4, 4, 2],
  ];

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
          BlocBuilder<FormationBloc, FormationState>(
            builder: (context, state) => PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) => BlocProvider.of<CurrentTeamBloc>(context).add(SetCurrentTeam(team: index + 1)),
              children: [_buildTeam(context, state, 1), _buildTeam(context, state, 2)],
            ),
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

  Stack _buildTeam(BuildContext context, FormationState state, int team) {
    final players = state.teams[team - 1];

    String teamText = " Team $team ";
    if (team == 1)
      teamText = " " + teamText + ">";
    else if (team == 2) teamText = "<" + teamText + " ";

    return Stack(
      children: [
        Stack(children: players.map((player) => PlayerDraggable(playerWithPosition: player)).toList()),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              BlocProvider.of<FormationBloc>(context).add(SetCustomFormation(team: team == 1 ? 2 : 1));
              if (team == 1) {
                controller.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              } else {
                controller.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(teamText, style: Theme.of(context).textTheme.bodyText1),
            ),
          ),
        ),
      ],
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
