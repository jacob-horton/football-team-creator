import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/pages/player_selector.dart';
import 'package:football/widgets/shirt.dart';

class PlayerDraggable extends StatelessWidget {
  static const double size = 90;
  final PlayerWithPosition playerWithPosition;

  PlayerDraggable({Key? key, required this.playerWithPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Size currentSize = MediaQuery.of(context).size;
    //if (currentSize != previousSize) {
    //  double xScale = currentSize.width / previousSize.width;
    //  double yScale = currentSize.height / previousSize.height;
//
    //  offset = Offset(offset.dx * xScale, offset.dy * yScale);
    //  previousSize = currentSize;
    //}

    return Positioned(
      left: playerWithPosition.position.x,
      top: playerWithPosition.position.y,
      child: GestureDetector(
        onTap: () async {
          Object? newPlayer = await Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => PlayerSelector(
                multiselect: false,
                initialPlayer: playerWithPosition.player,
              ),
            ),
          );

          if (newPlayer is Player) BlocProvider.of<FormationBloc>(context).add(SwapPlayer(oldPlayer: playerWithPosition, newPlayer: newPlayer));
        },
        onPanUpdate: (details) {
          Size windowSize = MediaQuery.of(context).size;

          // Clamp to border of window
          double offX = _clamp(playerWithPosition.position.x + details.delta.dx, 0, windowSize.width - PlayerDraggable.size);
          double offY = _clamp(playerWithPosition.position.y + details.delta.dy, 0, windowSize.height - PlayerDraggable.size);

          // Correct offset when mouse moved outside window
          if (details.globalPosition.dx < 0) offX = 0;
          if (details.globalPosition.dy < 0) offY = 0;
          if (details.globalPosition.dx > windowSize.width) offX = windowSize.width - size;
          if (details.globalPosition.dy > windowSize.height) offY = windowSize.height - size;

          BlocProvider.of<FormationBloc>(context, listen: false).add(
            SetPlayerPosition(
              playerPosition: playerWithPosition.position.copyWith(
                playerId: playerWithPosition.player.id,
                team: 1,
                x: offX,
                y: offY,
              ),
            ),
          );
        },
        onPanEnd: (_) {
          final bloc = BlocProvider.of<FormationBloc>(context);
          bloc.add(SetCustomFormation(team: playerWithPosition.position.team));
          bloc.add(SaveFormation());
        },
        child: Container(
          width: PlayerDraggable.size,
          height: PlayerDraggable.size,
          child: Shirt(
            player: playerWithPosition.player,
            showNumber: true,
            showName: true,
            size: size,
          ),
        ),
      ),
    );
  }

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
