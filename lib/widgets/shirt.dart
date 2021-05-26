import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/utils/shirt_colours.dart';

class Shirt extends StatelessWidget {
  Shirt({Key? key, required this.size, required this.colour, this.player, this.showNumber = false, this.showName = false}) : super(key: key);

  final double size;
  final Player? player;
  final String? colour;
  final bool showNumber;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: ShirtClip(size),
          child: SvgPicture.asset(
            'assets/shirt.svg',
            width: size,
            height: size,
            color: ShirtColours.colours[colour],
            colorBlendMode: BlendMode.color,
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showName
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: size / 4),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            player?.name.split(' ').last.toUpperCase() ?? '',
                            style: TextStyle(
                              letterSpacing: -0.1,
                              fontSize: size / 8,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                showNumber
                    ? Text(player?.number.toString() ?? '', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: size / 3))
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShirtClip extends CustomClipper<Path> {
  late Path path;

  ShirtClip(double size) {
    path = Path();
    path.lineTo(size * 0.78, size * 0.09);
    path.cubicTo(size * 0.59, size * 0.09, size * 0.39, size * 0.09, size / 5, size * 0.09);
    path.cubicTo(size * 0.18, size * 0.09, size * 0.16, size * 0.11, size * 0.14, size * 0.12);
    path.cubicTo(size * 0.13, size * 0.14, size * 0.12, size * 0.16, size * 0.11, size * 0.18);
    path.cubicTo(size * 0.08, size * 0.23, size * 0.05, size * 0.27, size * 0.03, size * 0.32);
    path.cubicTo(size * 0.02, size * 0.34, size * 0.02, size * 0.36, size * 0.02, size * 0.39);
    path.cubicTo(size * 0.03, size * 0.41, size * 0.05, size * 0.44, size * 0.08, size * 0.45);
    path.cubicTo(size * 0.1, size * 0.46, size * 0.12, size * 0.48, size * 0.14, size * 0.49);
    path.cubicTo(size * 0.15, size * 0.49, size * 0.17, size * 0.49, size * 0.18, size * 0.49);
    path.cubicTo(size * 0.19, size / 2, size * 0.19, size / 2, size * 0.19, size * 0.51);
    path.cubicTo(size * 0.19, size * 0.62, size * 0.19, size * 0.72, size * 0.19, size * 0.82);
    path.cubicTo(size * 0.19, size * 0.87, size * 0.23, size * 0.91, size * 0.27, size * 0.91);
    path.cubicTo(size * 0.29, size * 0.91, size * 0.31, size * 0.91, size / 3, size * 0.91);
    path.cubicTo(size * 0.46, size * 0.91, size * 0.59, size * 0.91, size * 0.72, size * 0.91);
    path.cubicTo(size * 0.74, size * 0.91, size * 0.75, size * 0.91, size * 0.76, size * 0.9);
    path.cubicTo(size * 0.78, size * 0.89, size * 0.8, size * 0.86, size * 0.81, size * 0.83);
    path.cubicTo(size * 0.81, size * 0.81, size * 0.81, size * 0.79, size * 0.81, size * 0.77);
    path.cubicTo(size * 0.81, size * 0.68, size * 0.81, size * 0.59, size * 0.81, size * 0.49);
    path.cubicTo(size * 0.83, size * 0.49, size * 0.86, size * 0.49, size * 0.88, size * 0.48);
    path.cubicTo(size * 0.9, size * 0.46, size * 0.92, size * 0.45, size * 0.94, size * 0.44);
    path.cubicTo(size * 0.97, size * 0.42, size, size * 0.38, size * 0.98, size * 0.34);
    path.cubicTo(size * 0.98, size / 3, size * 0.97, size * 0.31, size * 0.96, size * 0.3);
    path.cubicTo(size * 0.93, size / 4, size * 0.9, size * 0.19, size * 0.87, size * 0.13);
    path.cubicTo(size * 0.85, size * 0.11, size * 0.83, size * 0.1, size * 0.81, size * 0.09);
    path.cubicTo(size * 0.8, size * 0.09, size * 0.79, size * 0.09, size * 0.78, size * 0.09);
    path.cubicTo(size * 0.78, size * 0.09, size * 0.78, size * 0.09, size * 0.78, size * 0.09);
  }

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
