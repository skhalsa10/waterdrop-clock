import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_again/water-drop-painter.dart';
import 'package:flutter_app_again/water.dart';

//okay let me try this again
class WaterDrop extends StatefulWidget {
  Size _size;
  int _scale;

  WaterDrop(this._size, this._scale);

  @override
  State<WaterDrop> createState() => WaterDropState(_size, _scale);
}

//this is the state for the
class WaterDropState extends State<WaterDrop>
    with SingleTickerProviderStateMixin {
  List<Water> _ledge;
  bool _repaintPlease;
  Size _size;
  int _scale;
  AnimationController controller;
  Animation<double> animation;

  WaterDropState(this._size, this._scale);

  @override
  void initState() {
    super.initState();
    _repaintPlease = false;
    _ledge = [];

    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1),
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    //animation.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(painter: WaterDropPainter(_repaintPlease, _ledge)),
    );
  }
}
