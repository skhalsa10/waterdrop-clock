// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:ui';
import 'water.dart';

/// Here we have the water when it Drips off the ledge this
/// will define the way it looks falling to the ground and how it moves over time.
/// it has some simple collision detection that signals conversion into a SPLASH!
class Drip implements Water {
  double _x;
  double _y;
  int _scale;
  bool _hasHitBottom;
  int _counter;
  double _height;

  Drip(this._x, this._scale, this._height) {
    _y = 0;
    _hasHitBottom = false;
    _counter = 0;
  }

  bool get hasHitBottom => _hasHitBottom;

  double get x => _x;

  @override
  void render(Canvas canvas, Paint paint) {
    paint = paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color.fromARGB(255, 0, 0, 0);

    canvas.drawOval(Rect.fromLTWH(_x, _y, 3.0 * _scale, 3.0 * _scale), paint);
    double xoffset1 = (3.0 * _scale) / 8;
    canvas.drawOval(
        Rect.fromLTWH(_x + xoffset1, _y - 3, 2.0 * _scale, 3.0 * _scale),
        paint);
    double xoffset2 = (2.0 * _scale) / 4;
    xoffset2 += xoffset1;
    canvas.drawOval(
        Rect.fromLTWH(_x + xoffset2, _y - 6, 1.0 * _scale, 2.0 * _scale),
        paint);

    _y = _y + (1 + _counter);
    _counter++;

    if (_y >= _height) {
      //println(height);
      _hasHitBottom = true;
    }
  }
}
