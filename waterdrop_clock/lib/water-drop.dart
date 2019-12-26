// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_again/water-drop-painter.dart';
import 'package:flutter_app_again/water.dart';

import 'drip.dart';
import 'drop.dart';
import 'splash.dart';

/// The WaterDropClock merges the WaterDrop animation with a clock
/// it will take a size and a scale.
/// it will use a CustomPaint to paint the animation to.
/// it will also center a digital clock
class WaterDropClock extends StatefulWidget {
  Size _size;
  final int _scale;

  WaterDropClock(Size _size, this._scale) {
    //we want landscape this will fix the bug where the mediaquery.of
    // gets the portrait size.
    //TODO I should pull this out of the widget
    if (_size.height > _size.width) {
      this._size = Size(_size.height, _size.width);
    } else {
      this._size = _size;
    }
  }

  @override
  State<WaterDropClock> createState() => _WaterDropClockState(_size, _scale);
}

class _WaterDropClockState extends State<WaterDropClock> {
  _WaterDropClockState(this.size, this._scale);

  //this list is used to keep track of the water  as
  // it converts through the three states.
  List<Water> _ledge;
  bool _repaintPlease;
  Size size;

  int _scale;
  Ticker _ticker;
  Random _rand;
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _rand = Random();
    _repaintPlease = false;
    _ledge = List((size.width / (8 * _scale)).floor());
    //we want to step through state every Tick
    _ticker = Ticker(_onTick);

    //initialize the list of water with empty Drops
    for (int i = 0; i < _ledge.length; i++) {
      _ledge[i] =
          Drop(((i * 8 * _scale) + ((size.width % (8 * _scale)) / 2)), _scale);
    }

    //lets start the ticket
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: WaterDropPainter(_repaintPlease, _ledge),
      ),
    );
  }

  //this animation in this widget will need
  // to update every tick and paint very tick
  void _onTick(Duration elapsed) {
    //lets step the state
    addWater();
    //paint the updated state
    setState(() {
      _repaintPlease = !_repaintPlease;
    });
    //update state that does not need to be painted
    update();
  }

  //after the ledge has been painted we need to go through this and convert
  //Drips to Splashes and Splashes to Drops if needed
  void update() {
    int ledgeLength = _ledge.length;

    for (int i = 0; i < ledgeLength; i++) {
      //change Drip to Splash
      if (_ledge.elementAt(i).runtimeType == Drip) {
        Drip drip = _ledge.elementAt(i);
        if (drip.hasHitBottom) {
          _ledge[i] = Splash(drip.x, size.height, _scale);
        }
      }
      //Change  the Splashes back to Drops
      if (_ledge.elementAt(i).runtimeType == Splash) {
        Splash splash = _ledge.elementAt(i);
        if (splash.isComplete()) {
          _ledge[i] = Drop(
              (i * 8 * _scale) + ((size.height % (8 * _scale)) / 2), _scale);
        }
      }
    }
  }

  // This function will pick a random spot in the ledge array and add water to it
  void addWater() {
    int i = _rand.nextInt(_ledge.length);

    //add water to Drop (only drops though) and change to a drip if needed
    if (_ledge.elementAt(i).runtimeType == Drop) {
      Drop drop = _ledge.elementAt(i);
      //randomly add water one at a time
      if (drop.addWater()) {
        _ledge[i] = Drip(drop.x + (8 * _scale) / 2, _scale, size.height);
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
