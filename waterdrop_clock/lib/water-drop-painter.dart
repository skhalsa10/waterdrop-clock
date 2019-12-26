// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'package:flutter/material.dart';
import 'package:flutter_app_again/color-elem.dart';

//I will be rendoring these hopefully
import 'water.dart';

//why is this not working the way I want to! grr
//take 2 from scratch
//here I will pass in a boolean that will be switched from outside of this painter
// in a set state
class WaterDropPainter extends CustomPainter {
  WaterDropPainter(this._repaint, this._ledge, this._theme);
  bool _repaint;
  List<Water> _ledge;
  bool please = false;
  final Map<ThemeElement, Color> _theme;

  bool get repaint => _repaint;

  @override
  void paint(Canvas canvas, Size size) {
    //print(_ledge.length);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = _theme[ThemeElement.background]
      ..strokeWidth = 5.0;
    //canvas.drawRect(Rect.fromLTWH(.0, 0.0, size.width, size.height), paint);
    canvas.drawPaint(paint);
    //change the color to be not the background
    paint.color = _theme[ThemeElement.text];
    for (Water w in _ledge) {
      w.render(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(WaterDropPainter oldDelegate) {
    //lets just return true for now
    if (oldDelegate._repaint != _repaint) {
      return true;
    }
    return false;
  }
}
