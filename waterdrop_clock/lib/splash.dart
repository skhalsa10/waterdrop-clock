// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'water.dart';

/// This class represents the splash of the water. these will get created as the
/// water collides with the ground or the clock(if I can figure out this
/// collision detection in time :)
class Splash implements Water {
  // I never see people using private variables in dart and flutter...
  // ... maybe I just have not seen enough code? I will mkae everything
  // private if I can... if only because I am used to that.
  double _x1;
  double _x2;
  double _x3;
  double _y1;
  double _y2;
  double _y3;
  int _scale;
  double _vel1;
  double _vel2;
  double _vel3;
  int _frame; // the fram will keeptrack of the upward direction of the splash
  int _counter;
  double _height;
  Random _rand;
  int _counter2;

  ///
  /// I know there is a better way to contruct stuff in dart but I think I lose
  /// the ability to take advantage of this awesomeness due to my need to
  /// initialize many variables here
  ///
  Splash(x, y, height, scale) {
    _rand = Random();
    _x1 = x;
    _x2 = x;
    _x3 = x;
    _height = height;
    _scale = scale;
    _y1 = y;
    _y2 = y;
    _y3 = y;
    //splashes to the left
    _vel1 = 1 + (6 * -_rand.nextDouble());
    //splashes verticle...ish
    _vel2 = -1 + (2 * _rand.nextDouble());
    //splashes to the right
    _vel3 = 1 + (6 * _rand.nextDouble());
    _counter = 0;
    _frame = 10;
    _counter2 = 0;
  }

  /// The splash will render as three circles that move in a random direction.
  /// this looks cool. It is probably not the most accurate lookish splash...
  /// but I am fine with this. We will render on the canvas and use the passed in
  /// Paint to do so.
  @override
  void render(Canvas canvas, Paint paint) {
    //I have never used syntax like this is this correct?
    //do I even need the assignment operator?
    paint = paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    double w = 1.0 * _scale;
    double h = 1.0 * _scale;
    canvas.drawOval(Rect.fromLTWH(_x1, _y1 - (h / 2), w, h), paint);
    canvas.drawOval(Rect.fromLTWH(_x2, _y2 - (h / 2), w, h), paint);
    canvas.drawOval(Rect.fromLTWH(_x3, _y3 - (h / 2), w, h), paint);
    _updateSplash();
  }

  ///This will update the location of each piece of the splash
  void _updateSplash() {
    if (_frame < 0) {
      _y1 += _counter2++;
      _y2 += _counter2++;
      _y3 += _counter2++;
    }
    _updateSplash1();
    _updateSplash2();
    _updateSplash3();
    _frame--;
  }

  //there is probably a better way to write the next three functions
  //will refactor when if I have time.
  void _updateSplash1() {
    //if the splash is right above the ground we want it to stay on the ground
    if ((_frame <= 0) && _y1 >= _height - 1) {
      _y1 = _height - 1;
      return;
    }
    _x1 += _vel1;
    if (_frame > 0) {
      _y1 -= (3);
    } else {
      _y1 += (3);
    }
  }

  void _updateSplash2() {
    if ((_frame <= 0) && _y2 >= _height - 1) {
      _y2 = _height - 1;
      return;
    }
    _x2 += _vel2;
    if (_frame > 0) {
      _y2 -= (3);
    } else {
      _y2 += (3);
    }
  }

  void _updateSplash3() {
    if ((_frame <= 0) && _y3 >= _height - 1) {
      _y3 = _height - 1;
      return;
    }
    _x3 += _vel3;
    if (_frame > 0) {
      _y3 -= (3);
    } else {
      _y3 += (3);
    }
  }

  /// this will return true if the splash has reaches a spot to despawn
  bool isComplete() {
    if ((_frame <= 0) &&
        (_y1 <= _height) &&
        (_y2 <= _height) &&
        (_y3 <= _height)) {
      if (_counter == 100) {
        return true;
      } else {
        _counter++;
      }
    }
    return false;
  }
}
