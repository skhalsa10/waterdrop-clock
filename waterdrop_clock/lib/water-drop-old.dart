import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_again/water.dart';

import 'drop.dart';
import 'drip.dart';
import 'splash.dart';

///Here I will port over my own animated creation. I tend to make it my hello
///world of a new language. It should actually look extremely cool as a face clock!
///Due to its weather related inspiration it could actually be  1 of many animations
///that can change dynamically with with current weather:). this is not a new idea
///and it is incorporated in most weather apps. I am trying to learn flutter though
///and finish my first ever contest. check out the animation on my portfolio
/// https://www.snizzle.me there you will find a free friend link to a medium article
/// describing a port to javascript.
///

///Okay this is my first real flutter app I know a little bit about flutter
///I am thinking that I will bring in my animation by making it a StatefulWidget
class WaterDrop extends StatefulWidget {
  final Size _size;
  final int _scale;

  WaterDrop(this._size, this._scale);

  @override
  _WaterDropState createState() => _WaterDropState(_size, _scale);
}

/// I was trying to use animation Controller but I dont think this will work for me
/// based on my research it seems like this defines an animation that has a beginning and end
/// I want something more like a game loop with endless animation
/// I will try to implement a timer that repaints the canvas and also changes the state
class _WaterDropState extends State<WaterDrop> with TickerProviderStateMixin {
  Timer animationTrigger;
  List<Water> _ledge = [];
  Size size;
  int _scale;
  bool timeToRepaint;
  Random _rand;
  WaterDropPainter thePainter;

  _WaterDropState(this.size, this._scale);

  @override
  void initState() {
    super.initState();
    timeToRepaint = false;
    _rand = Random();
    animationTrigger = Timer.periodic(Duration(milliseconds: 17), callback);

    //initialize the list of water with empty Drops
    for (int i = 0; i < size.width / (8 * _scale); i++) {
      _ledge.insert(i,
          Drop(((i * 8 * _scale) + ((size.width % (8 * _scale)) / 2)), _scale));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaterDropPainter(
        _ledge,
      ),
      size: size,
    );
  }

  // this call back will be triggered 60 times per second we can use this to animate
  void callback(Timer timer) {
    //print("is this running every 17 ms?");
    //print(_ledge);
    //add a single drop of water
    addWater();

    //render the animation
//    for(Water water: ledge){
//      water.render();
//    }
    setState(() {
      this._ledge = _ledge;
    });
    //update types
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
          _ledge.insert(i, Splash(drip.x, size.height, _scale));
        }
      }
      //Change  the Splashes back to Drops
      if (_ledge.elementAt(i).runtimeType == Splash) {
        Splash splash = _ledge.elementAt(i);
        if (splash.isComplete()) {
          _ledge.insert(
            i,
            Drop((i * 8 * _scale) + ((size.width % (8 * _scale)) / 2), _scale),
          );
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
        _ledge.insert(i, Drip(drop.x + (8 * _scale) / 2, _scale, size.height));
      }
    }
  }

  @override
  void dispose() {
    animationTrigger.cancel();
  }
}

// I wanted to figure out how to repaint using a listener attached to the
// Timer that is set up in the water drop State. I may keep trying... but first
// Let me see if I can set a boolean flag to that forces a repaint
class WaterDropPainter extends CustomPainter {
  WaterDropPainter(
    this._ledge,
  );
  List<Water> _ledge;

  @override
  void paint(Canvas canvas, Size size) {
    print("Painting dude");
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.amber;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(WaterDropPainter old) {
    if (old._ledge != _ledge) {
      return true;
    }
    return false;
  }
}
