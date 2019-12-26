// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'water.dart';

/// The drop class represents the idea of watter pooling up on a ledge
/// Eventually the drop gets so heavy it gets converted into a Drip
class Drop implements Water {
  int _waterRenderState;
  double _x;
  //bool readyToDrip;
  int _scale;

  Drop(this._x, this._scale) {
    _waterRenderState = 0;
  }

  Drop.withWater(this._x, this._scale) {
    _waterRenderState = 1;
  }

  double get x => _x;

  //returns true if readyToDrip
  bool addWater() {
    if (_waterRenderState == 4) {
      //readyToDrip = true;
      _waterRenderState = 0;
      return true;
    } else {
      _waterRenderState++;
      return false;
    }
  }

  /// depending on how much water is located in this section it will render
  /// it visually different before it eventually bursts into a Drip.
  @override
  void render(Canvas canvas, Paint paint) {
    paint = paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color.fromARGB(255, 0, 0, 0);

    if (_waterRenderState == 0) {
      return;
    }
    if (_waterRenderState == 1) {
      //one drop of water
      canvas.drawOval(
        Rect.fromLTWH(
          x + 2 * _scale,
          -2,
          4.0 * _scale,
          2.0 * _scale,
        ),
        paint,
      );
      return;
    }
    if (_waterRenderState == 2) {
      //DROP1
      canvas.drawOval(Rect.fromLTWH(x, -2, 4.0 * _scale, 2.0 * _scale), paint);
      //drop 2
      canvas.drawOval(
          Rect.fromLTWH(x + 4 * _scale, -2, 4.0 * _scale, 2.0 * _scale), paint);
      return;
    }
    if (_waterRenderState == 3) {
      //drop 1
      canvas.drawOval(Rect.fromLTWH(x, -2, 4.0 * _scale, 2.0 * _scale), paint);

      //drop 2
      canvas.drawOval(
          Rect.fromLTWH(x + 4 * _scale, -2, 4.0 * _scale, 2.0 * _scale), paint);

      //drop 3 TODO should this be x+2*_scale?
      canvas.drawOval(
          Rect.fromLTWH(x + 2, -2, 4.0 * _scale, 2.0 * _scale), paint);
      return;
    }
    if (_waterRenderState == 4) {
      //drop 1
      canvas.drawOval(Rect.fromLTWH(x, -2, 4.0 * _scale, 2.0 * _scale), paint);
      //drop 2
      canvas.drawOval(
          Rect.fromLTWH(x + 4 * _scale, -2, 4.0 * _scale, 2.0 * _scale), paint);
      //drop 3
      canvas.drawOval(
          Rect.fromLTWH(x + 2 * _scale, -2, 4.0 * _scale, 2.0 * _scale), paint);
      //drop 4
      canvas.drawOval(
          Rect.fromLTWH(x + 2 * _scale, 1, 4.0 * _scale, 2.0 * _scale), paint);
      return;
    }
  }
}
