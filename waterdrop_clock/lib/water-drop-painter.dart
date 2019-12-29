// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_again/color-elem.dart';

import 'water.dart';

/// the water drop painter must be used with the WaterDrop class.
/// It will take in the array of water and render it on the canvas.
/// It will use the map of theme colors set in the WaterDropClock
class WaterDropPainter extends CustomPainter {
  WaterDropPainter(
    this._repaint,
    this._ledge,
    this._theme,
    this._hour,
    this._minute,
  );

  bool _repaint;
  List<Water> _ledge;
  bool please = false;
  final Map<ThemeElement, Color> _theme;
  String _hour;
  String _minute;
  TextSpan _hourSpan;
  TextSpan _minuteSpan;
  TextPainter _hourPainter;
  TextPainter _minutePainter;

  bool get repaint => _repaint;

  @override
  void paint(Canvas canvas, Size size) {
    final fontSize = size.width / 3.5;
    final defaultStyle = TextStyle(
      color: _theme[ThemeElement.text],
      fontFamily: 'Josefin Sans',
      fontSize: fontSize,
    );
    _hourSpan = TextSpan(
      text: _hour,
      style: defaultStyle,
    );
    _hourPainter = TextPainter(
      text: _hourSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.right,
    )..layout(maxWidth: size.width / 2);

    _minuteSpan = TextSpan(
      text: _minute,
      style: defaultStyle,
    );
    _minutePainter = TextPainter(
      text: _minuteSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width / 2);

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
    _hourPainter.layout(maxWidth: size.width / 2);
    //_hourPainter.
    _minutePainter.layout(maxWidth: size.width / 2);
    _hourPainter.paint(
      canvas,
      Offset(
        size.width / 8,
        (size.height - _hourPainter.height) / 2,
      ),
    );
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(
          size.width / 8,
          (size.height - _hourPainter.height) / 2,
        ),
        Offset(
          size.width / 8 + _hourPainter.width,
          (size.height - _hourPainter.height) / 2,
        ),
        paint);
//    canvas.drawRect(
//        Rect.fromLTWH(
//          size.width / 8,
//          (size.height - _hourPainter.height) / 2,
//          _hourPainter.width,
//          _hourPainter.height,
//        ),
//        paint);
    _minutePainter.paint(
      canvas,
      Offset(
        size.width - (size.width / 8) - _minutePainter.width,
        (size.height - _hourPainter.height) / 2,
      ),
    );
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
