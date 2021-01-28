import 'package:flutter/material.dart';


/// Custom painter for action buttons.
class ButtonCustomPainter extends CustomPainter {
  final buttonColor;
  final playerNum;
  final actionNum;
  ButtonCustomPainter(this.buttonColor, this.playerNum, this.actionNum);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = buttonColor..style = PaintingStyle.fill;

    if (actionNum == 0) {
      Path path = Path()..moveTo(0, size.height*0.05);
      path.quadraticBezierTo(size.width*0.30, 0, size.width, size.height*0.40);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else if (actionNum == 1) {
      Path path = Path()..moveTo(0, size.height*0.40);
      path.quadraticBezierTo(size.width*0.50, size.height*0.75, size.width, size.height*0.40);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      Path path = Path()..moveTo(0, size.height*0.40);
      path.quadraticBezierTo(size.width*0.70, 0, size.width, size.height*0.05);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}