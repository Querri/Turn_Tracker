import 'package:flutter/material.dart';



/// Custom painter for action buttons.
class ButtonCustomPainter extends CustomPainter {
  final buttonColor;
  final playerNum;
  final actionNum;

  ButtonCustomPainter(this.buttonColor, this.playerNum, this.actionNum);

  List<double> startPoint;
  List<double> curve1;
  List<double> curve2;
  List<double> curve3;
  List<double> endPoint;

  @override
  void paint(Canvas canvas, Size size) {
    startPoint = [0, size.height*0.05];
    curve1 = [size.width*0.30, 0, size.width, size.height*0.40];
    curve2 = [size.width*0.50, size.height*0.75, size.width, size.height*0.40];
    curve3 = [size.width*0.70, 0, size.width, size.height*0.05];
    endPoint = [size.width, size.height*0.05];

    Paint paint = Paint()..color = buttonColor..style = PaintingStyle.fill;

    double start;
    List<double> values;
    switch (actionNum) {
      case 0: {
        start = startPoint[1];
        values = curve1;
        break;
      }
      case 1: {
        start = curve1[3];
        values = curve2;
        break;
      }
      case 2: {
        start = curve2[3];
        values = curve3;
      }
    }

    Path path = Path()..moveTo(0, start);
    path.quadraticBezierTo(values[0], values[1], values[2], values[3]);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}