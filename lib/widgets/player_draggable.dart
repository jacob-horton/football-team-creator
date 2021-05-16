import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/pages/player_selector.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/utils/shirt_colours.dart';

class PlayerDraggable extends StatelessWidget {
  static const double size = 90;
  final PlayerWithPosition playerWithPosition;
  final clipper = ShirtClip(PlayerDraggable.size);

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
        onTap: () => Navigation.navigateTo(context, PlayerSelector(multiselect: false)),
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
          child: Stack(
            children: [
              ClipPath(
                clipper: clipper,
                child: SvgPicture.asset(
                  'assets/shirt.svg',
                  width: PlayerDraggable.size,
                  height: PlayerDraggable.size,
                  color: ShirtColours.colours[playerWithPosition.player.colour],
                  colorBlendMode: BlendMode.color,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(playerWithPosition.player.number.toString(), style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 30.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          playerWithPosition.player.name.split(' ').last.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: -0.1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

class ShirtClip extends CustomClipper<Path> {
  late Path path;

  ShirtClip(double size) {
    path = Path();
    path.lineTo(size / 5, size * 0.08);
    path.cubicTo(size * 0.18, size * 0.08, size * 0.17, size * 0.08, size * 0.16, size * 0.09);
    path.cubicTo(size * 0.14, size * 0.1, size * 0.13, size * 0.12, size * 0.12, size * 0.13);
    path.cubicTo(size * 0.12, size * 0.13, size * 0.02, size * 0.3, size * 0.02, size * 0.3);
    path.cubicTo(-0.01, size * 0.36, size * 0.01, size * 0.43, size * 0.06, size * 0.46);
    path.cubicTo(size * 0.06, size * 0.46, size * 0.12, size * 0.49, size * 0.12, size * 0.49);
    path.cubicTo(size * 0.14, size / 2, size * 0.16, size * 0.51, size * 0.18, size * 0.51);
    path.cubicTo(size * 0.18, size * 0.51, size * 0.18, size * 0.82, size * 0.18, size * 0.82);
    path.cubicTo(size * 0.18, size * 0.87, size * 0.23, size * 0.92, size * 0.28, size * 0.92);
    path.cubicTo(size * 0.28, size * 0.92, size * 0.72, size * 0.92, size * 0.72, size * 0.92);
    path.cubicTo(size * 0.77, size * 0.92, size * 0.82, size * 0.87, size * 0.82, size * 0.82);
    path.cubicTo(size * 0.82, size * 0.82, size * 0.82, size * 0.51, size * 0.82, size * 0.51);
    path.cubicTo(size * 0.84, size * 0.51, size * 0.86, size / 2, size * 0.88, size * 0.49);
    path.cubicTo(size * 0.88, size * 0.49, size * 0.94, size * 0.46, size * 0.94, size * 0.46);
    path.cubicTo(size, size * 0.43, size, size * 0.36, size * 0.98, size * 0.3);
    path.cubicTo(size * 0.98, size * 0.3, size * 0.88, size * 0.13, size * 0.88, size * 0.13);
    path.cubicTo(size * 0.87, size * 0.12, size * 0.86, size * 0.1, size * 0.84, size * 0.09);
    path.cubicTo(size * 0.83, size * 0.08, size * 0.82, size * 0.08, size * 0.8, size * 0.08);
    path.cubicTo(size * 0.8, size * 0.08, size * 0.72, size * 0.08, size * 0.72, size * 0.08);
    path.cubicTo(size * 0.72, size * 0.08, size * 0.28, size * 0.08, size * 0.28, size * 0.08);
    path.cubicTo(size * 0.28, size * 0.08, size / 5, size * 0.08, size / 5, size * 0.08);
  }

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
