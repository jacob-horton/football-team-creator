import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_team/current_team_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/bloc/formation_layouts/formation_layouts_bloc.dart';
import 'package:football/pages/team_editor.dart';
import 'package:football/widgets/formation_dropdown.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:football/widgets/rounded_container.dart';

class MainPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

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
              onPageChanged: (index) {
                BlocProvider.of<CurrentTeamBloc>(context).add(SetCurrentTeam(team: index + 1));
              },
              children: List.generate(2, (index) => _buildTeam(context, state, index + 1)),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                BlocBuilder<FormationLayoutsBloc, FormationLayoutsState>(
                  builder: (context, state) {
                    if (state is FormationLayout)
                      return FormationDropdown(formations: state.formations);
                    else if (state is FormationLayoutsInitial)
                      return FormationDropdown(formations: []); 
                    else
                      return FormationDropdown(formations: []);
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

  Widget _buildTeam(BuildContext context, FormationState state, int team) {
    final players = state.players.where((player) => player.position.team == team);
    final newTeam = team == 1 ? 2 : 1;

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
              BlocProvider.of<FormationBloc>(context).add(SetCustomFormation(team: newTeam));
              
              BlocProvider.of<FormationLayoutsBloc>(context, listen: false)
                  .add(SetFormationLayoutSize(size: state.players.where((p) => p.position.team == newTeam).length));
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
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TeamEditor())),
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
