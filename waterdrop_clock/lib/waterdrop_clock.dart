// Copyright 2019 Siri Khalsa

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
/// water drop animation. I have borrowed alot from the example digital clock
/// example handed out by the flutter team.
/// Version1 the drops do not interact with the time
/// Version2 attempt to splash after it hits the time
class WaterDropClock extends StatefulWidget {
  const WaterDropClock(this.model);
  final ClockModel model;

  @override
  _WaterDropClockState createState() => _WaterDropClockState();
}

class _WaterDropClockState extends State<WaterDropClock> {
  DateTime _dateTime;
  Timer _timer;
  Size _sizeOfClock;

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
    final fontSize = MediaQuery.of(context).size.width / 4.5;
    final defaultStyle = TextStyle(
      color: colors[ThemeElement.text],
      fontFamily: 'Josefin Sans',
      fontSize: fontSize,
    );

    return Container(
      color: colors[ThemeElement.shadow],
      child: DefaultTextStyle(
        style: defaultStyle,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  _sizeOfClock = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return WaterDrop(
                    _sizeOfClock,
                    2,
                    colors,
                  );
                }),
                Align(
                  alignment: Alignment(-.85, 0),
                  child: Text(hour),
                ),
                Align(
                  alignment: Alignment(.85, 0),
                  child: Text(minute),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
