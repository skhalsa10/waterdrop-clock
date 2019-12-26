// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'color-elem.dart';
import 'water-drop.dart';

final _lightTheme = {
  ThemeElement.background: Color.fromARGB(255, 133, 133, 133),
  ThemeElement.text: Color.fromARGB(255, 0, 0, 0),
  ThemeElement.shadow: Color.fromARGB(100, 0, 0, 0),
};

final _darkTheme = {
  ThemeElement.background: Color.fromARGB(255, 0, 0, 0),
  ThemeElement.text: Color.fromARGB(255, 133, 133, 133),
  ThemeElement.shadow: Color.fromARGB(100, 133, 133, 133),
};

/// I have made a Water drop clock it will display the time with a cool
/// water drop animation.
class WaterDropClock extends StatefulWidget {
  const WaterDropClock(this.model);

  final ClockModel model;

  @override
  _WaterDropClockState createState() => _WaterDropClockState();
}

class _WaterDropClockState extends State<WaterDropClock> {
  DateTime _dateTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(WaterDropClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[ThemeElement.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[ThemeElement.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
        color: colors[ThemeElement.shadow],
        child: Stack(
          children: <Widget>[
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return WaterDrop(
                Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
                2,
                colors,
              );
            }),
            Positioned(
                left: 14,
                top: 0,
                child: Text(
                  hour,
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        )
//      Center(
//        child:
//        DefaultTextStyle(
//          style: defaultStyle,
//          child: Stack(
//            children: <Widget>[
//              Positioned(left: offset, top: 0, child: Text(hour)),
//              Positioned(right: offset, bottom: offset, child: Text(minute)),
//            ],
//          ),
//        ),
//      ),
        );
  }
}
