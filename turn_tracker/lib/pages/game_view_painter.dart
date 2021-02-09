import 'package:flutter/material.dart';



/// Custom painter for action buttons.
class ButtonCustomPainter extends CustomPainter {
  final buttonColor;
  final int playerNum;
  final int actionNum;
  final int numberOfActions;

  ButtonCustomPainter(this.buttonColor, this.playerNum, this.actionNum, this.numberOfActions);

  List<double> startPoint;
  List<double> endPoint;
  List<List<double>> curves;

  @override
  void paint(Canvas canvas, Size size) {
    startPoint = [0, size.height*0.05];
    endPoint = [size.width, size.height*0.05];
    curves = _getCurves(size.width, size.height);

    Paint paint = Paint()..color = buttonColor..style = PaintingStyle.fill;
    Path path;

    switch (numberOfActions) {
      case 1: {
        path = Path()..moveTo(0, startPoint[1]);
        for (var curve in curves) {
          path.quadraticBezierTo(curve[0], curve[1], curve[2], curve[3]);
        }
        break;
      }
      case 2: {
        switch (actionNum) {
          case 0: {
            path = Path()..moveTo(0, startPoint[1]);
            path.quadraticBezierTo(curves[0][0], curves[0][1], curves[0][2], curves[0][3]);
            path.quadraticBezierTo(curves[1][0], curves[1][1], curves[1][2], curves[1][3]);
            break;
          }
          case 1: {
            path = Path()..moveTo(0, curves[1][3]);
            path.quadraticBezierTo(curves[2][0], curves[2][1], curves[2][2], curves[2][3]);
            path.quadraticBezierTo(curves[3][0], curves[3][1], curves[3][2], curves[3][3]);
            break;
          }
        }
        break;
      }
      case 3: {
        switch (actionNum) {
          case 0: {
            path = Path()..moveTo(0, startPoint[1]);
            path.quadraticBezierTo(curves[0][0], curves[0][1], curves[0][2], curves[0][3]);
            break;
          }
          case 1: {
            path = Path()..moveTo(0, curves[0][3]);
            path.quadraticBezierTo(curves[1][0], curves[1][1], curves[1][2], curves[1][3]);
            path.quadraticBezierTo(curves[2][0], curves[2][1], curves[2][2], curves[2][3]);
            break;
          }
          case 2: {
            path = Path()..moveTo(0, curves[2][3]);
            path.quadraticBezierTo(curves[3][0], curves[3][1], curves[3][2], curves[3][3]);
            break;
          }
        }
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


  List<List<double>> _getCurves(width, height) {
    switch (numberOfActions) {
      case 1: {
        return [
          // curve x, curve y, end x, end y
          [width*(1/6), 0, width*(1/3), height*(2/5)],
          [width*(5/12), height*(3/5), width*(1/2), height*(3/5)],
          [width*(7/12), height*(3/5), width*(2/3), height*(2/5)],
          [width*(5/6), 0, width, height*0.05]
        ];
      }
      case 2: {
        return [
          // curve x, curve y, end x, end y
          [width*(1/3), 0, width*(2/3), height*(2/5)],
          [width*(5/6), height*(3/5), width, height*(3/5)],
          [width*(1/6), height*(3/5), width*(1/3), height*(2/5)],
          [width*(2/3), 0, width, height*0.05]
        ];
      }
      case 3: {
        return [
          // curve x, curve y, end x, end y
          [width*(1/2), 0, width, height*(2/5)],
          [width*(1/4), height*(3/5), width*(1/2), height*(3/5)],
          [width*(3/4), height*(3/5), width, height*(2/5)],
          [width*(1/2), 0, width, height*0.05]
        ];
      }
    }
  }
}