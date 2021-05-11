import 'package:flutter/material.dart';
import 'package:football/pages/player_selector.dart';
import 'package:football/utils/navigation.dart';

class TeamEditor extends StatelessWidget {
  TeamEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTeam(1)),
                VerticalDivider(width: 0, endIndent: 10, indent: 10),
                Expanded(child: _buildTeam(2)),
              ],
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigation.navigateTo(context, PlayerSelector(multiselect: true)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('SELECT PLAYERS'),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('SHUFFLE TEAMS'),
                ),
              ),
              Expanded(child: Container()),
              TextButton(onPressed: () => Navigation.pop(context), child: Text('CANCEL')),
              TextButton(onPressed: () => Navigation.pop(context), child: Text('OK')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(int teamNumber) {
    return Column(
      children: [
        Text('Team ${teamNumber.toString()}'),
        Expanded(child: ListView(children: [])),
        Text('Score: 50'),
      ],
    );
  }
}
