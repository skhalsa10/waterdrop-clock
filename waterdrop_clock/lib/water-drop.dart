// Copyright 2019 Siri Khalsa (github: skhalsa10).

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_again/water-drop-painter.dart';
import 'package:flutter_app_again/water.dart';

import 'color-elem.dart';
import 'drip.dart';
import 'drop.dart';
import 'splash.dart';

/// The WaterDropClock merges the WaterDrop animation with a clock
/// it will take a size and a scale.
/// To use this class property you must wrap in in a LayoutBuilder to obtain the
/// Size that it will be using. Feed it the max height and Max Width
/// it will use a CustomPaint to paint the animation to.
class WaterDrop extends StatefulWidget {
  final Size _size;
  final int _scale;
  final Map<ThemeElement, Color> _theme;

  final String _hour;
  final String _minute;

  WaterDrop(this._size, this._scale, this._theme, this._hour, this._minute);

  @override
  State<WaterDrop> createState() => _WaterDropState(_size, _scale);
}

class _WaterDropState extends State<WaterDrop> {
  _WaterDropState(this._size, this._scale);

  //this list is used to keep track of the water  as
  // it converts through the three states.
  List<Water> _ledge;
  bool _repaintPlease;
  Size _size;

  int _scale;
  Ticker _ticker;
  Random _rand;
  TextSpan _hourSpan;
  TextSpan _minuteSpan;
  TextPainter _hourPainter;
  TextPainter _minutePainter;

  @override
  void initState() {
    super.initState();
    _rand = Random();

    final fontSize = _size.width / 3.5;
    final TextStyle defaultStyle = TextStyle(
      color: widget._theme[ThemeElement.text],
      fontFamily: 'Josefin Sans',
      fontSize: fontSize,
    );
    _hourSpan = TextSpan(
      text: widget._hour,
      style: defaultStyle,
    );
    _hourPainter = TextPainter(
      text: _hourSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.right,
    )..layout(maxWidth: _size.width / 2);

    _minuteSpan = TextSpan(
      text: widget._minute,
      style: defaultStyle,
    );
    _minutePainter = TextPainter(
      text: _minuteSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.left,
    )..layout(maxWidth: _size.width / 2);

    _repaintPlease = false;
    _ledge = List((_size.width / (8 * _scale)).floor());
    //we want to step through state every Tick this is the magic for
    // making an endless animation. I could not figure out how to make an endless
    //animation with the Animation related built in widgets.
    _ticker = Ticker(_onTick);

    //initialize the list of water with empty Drops
    for (int i = 0; i < _ledge.length; i++) {
      _ledge[i] =
          Drop(((i * 8 * _scale) + ((_size.width % (8 * _scale)) / 2)), _scale);
    }

    //lets start the ticket
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRect(
        child: CustomPaint(
          size: _size,
          isComplex: true,
          painter: WaterDropPainter(
            _repaintPlease,
            _ledge,
            widget._theme,
            widget._hour,
            widget._minute,
          ),
        ),
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
    _hourPainter.layout(maxWidth: _size.width / 2);
    final lineMetrics = _hourPainter.computeLineMetrics();
    double startHourX = (_size.width / 8);
    double startHourY = (_size.height - _hourPainter.height) / 2;

    for (int i = 0; i < ledgeLength; i++) {
      //change Drip to Splash
      if (_ledge.elementAt(i).runtimeType == Drip) {
        Drip drip = _ledge.elementAt(i);
        if (drip.hasHitBottom) {
          _ledge[i] = Splash(drip.x, drip.y, _size.height, _scale);
        }
        //check if it hits the hour.
        if (drip.x >= startHourX && drip.x <= startHourX + _hourPainter.width) {
          if (drip.y > startHourY) {
            _ledge[i] = Splash(drip.x, drip.y, _size.height, _scale);
          }
        }
      }
      //Change  the Splashes back to Drops
      if (_ledge.elementAt(i).runtimeType == Splash) {
        Splash splash = _ledge.elementAt(i);
        if (splash.isComplete()) {
          _ledge[i] = Drop(
              (i * 8 * _scale) + ((_size.height % (8 * _scale)) / 2), _scale);
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
        _ledge[i] = Drip(drop.x + (8 * _scale) / 2, _scale, _size.height);
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
