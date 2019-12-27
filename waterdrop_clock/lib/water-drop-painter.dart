// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'package:flutter/material.dart';
import 'package:flutter_app_again/color-elem.dart';

import 'water.dart';

/// the water drop painter must be used with the WaterDrop class.
/// It will take in the array of water and render it on the canvas.
/// It will use the map of theme colors set in the WaterDropClock
class WaterDropPainter extends CustomPainter {
  WaterDropPainter(this._repaint, this._ledge, this._theme);
  bool _repaint;
  List<Water> _ledge;
  bool please = false;
  final Map<ThemeElement, Color> _theme;

  bool get repaint => _repaint;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = _theme[ThemeElement.background]
      ..strokeWidth = 5.0;
    //this works great if the custompainter is wrapped in a ClipRect
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
