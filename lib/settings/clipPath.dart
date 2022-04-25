import 'package:flutter/cupertino.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var x = 0.0;
    var increment = size.width ;


    path.cubicTo(x + increment / 2, 0, x + increment / 2, size.height,
        x + increment, size.height);

    path.lineTo(0, size.width);
    path.lineTo(0, 0);
    path.close();


    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}