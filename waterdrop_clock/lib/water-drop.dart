import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_again/water-drop-painter.dart';
import 'package:flutter_app_again/water.dart';

import 'drip.dart';
import 'drop.dart';
import 'splash.dart';

//okay let me try this again
class WaterDrop extends StatefulWidget {
  Size _size;
  int _scale;

  WaterDrop(this._size, this._scale);

  @override
  State<WaterDrop> createState() => WaterDropState(_size, _scale);
}

//Okay I have spent countless hours attempting to find what I want for animation
//I want a traditional game loop type animation. I want something that doesnt end.
//this may unfortunately be inefficient in Flutter because it is not just repainting
//a canvas like in what I am used to. I still found a stable way to do it!
//at forst I tried a Timer that initiated changes every 16.7 ms but it was just not very consistent
//I attempted to use the animation<double> and an AnimationController
//while I never got far enought to test it felt wrong
//during my research I foudn that the animation Timer utilizes a Ticker.
//A ticket ticks on every frame. I WANT THIS.
//I have added it and I am getting consistent ticks at 16.7 60 frames a second.
class WaterDropState extends State<WaterDrop> {
  List<Water> _ledge;
  bool _repaintPlease;
  //Timer timer;
  Size size;

  int _scale;
  Ticker ticker;
  Random _rand;

  WaterDropState(this.size, this._scale);

  @override
  void initState() {
    super.initState();
    //size = MediaQuery.of(context).size;
    _rand = Random();
    _repaintPlease = false;
    _ledge = List((size.width / (8 * _scale)).floor());
    ticker = Ticker(_onTick);
    ticker.start();
    //timer = Timer.periodic(Duration(milliseconds: 17), callback);
    //initialize the list of water with empty Drops
    for (int i = 0; i < _ledge.length; i++) {
      _ledge[i] =
          Drop(((i * 8 * _scale) + ((size.width % (8 * _scale)) / 2)), _scale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: WaterDropPainter(_repaintPlease, _ledge),
        child: Center(
          child: Text(
            "CLOCK",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }

  void _onTick(Duration elapsed) {
    //print(elapsed.inMilliseconds);
    addWater();
    setState(() {
      _repaintPlease = !_repaintPlease;
    });
    update();
  }

  void update() {
    int ledgeLength = _ledge.length;
    //this will update the ledge after a render and change water types
    //since the loop that calls this iterates over everything change the type as needed
    //add water converts Drops to Drips. this will convert
    // Drips to Splashes and Splashes to Drops

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

  void addWater() {
    //there are three types of updates needed one for Drop , Drip, and Splash;
    int i = _rand.nextInt(_ledge.length);

    //add water to Drop and change to a drip if needed
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
    ticker.dispose();
    super.dispose();
  }
}
