import 'package:flutter/material.dart';

//I will be rendoring these hopefully
import 'water.dart';

//why is this not working the way I want to! grr
//take 2 from scratch
//here I will pass in a boolean that will be switched from outside of this painter
// in a set state
class WaterDropPainter extends CustomPainter {
  bool _repaint;
  List<Water> _ledge;
  bool please = false;

  WaterDropPainter(this._repaint, this._ledge);

  bool get repaint => _repaint;

  @override
  void paint(Canvas canvas, Size size) {
    //print(_ledge.length);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color.fromARGB(255, 133, 133, 133)
      ..strokeWidth = 5.0;
    canvas.drawRect(Rect.fromLTWH(.0, 0.0, size.width, size.height), paint);
    for (Water w in _ledge) {
      w.render(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(WaterDropPainter oldDelegate) {
    //lets just return true for now
    if (oldDelegate._repaint != _repaint) {
      //print("oldDelegate._repaint is ${oldDelegate._repaint}");
      //print("_repaint is ${_repaint}");
      return true;
    }
    print("should paint will be False");
    return false;
  }
}
