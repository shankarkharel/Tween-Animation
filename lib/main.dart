// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Tree',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:
              const TextTheme(bodyText1: TextStyle(color: Colors.white))),
      home: const MyTree(),
    );
  }
}

class MyTree extends StatefulWidget {
  const MyTree({Key? key}) : super(key: key);

  @override
  _MyTreeState createState() => _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playMusic();
  }

  playMusic() async {
    await player.play(AssetSource("jingle.mp3"));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  static final _offsets = _generateOffsets(100, 0.05).toList(growable: false);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
        child: ListView(
          children: <Widget>[
            const Center(
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            for (final x in _offsets)
              Light(
                x: x,
              ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: Text("Happy Holidays"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text("Stop"),
              onPressed: () {
                player.stop();
              },
            )
          ],
        ),
      ),
    );
  }

  static Iterable<double> _generateOffsets(
      int count, double acceleration) sync* {
    double x = 0;
    yield x;

    double ax = acceleration;
    for (int i = 0; i < count; i++) {
      x += ax;
      ax *= 1.5;

      final maxLateral = min(1, i / count);
      if (x.abs() > maxLateral) {
        x = maxLateral * x.sign;
        ax = x >= 0 ? -acceleration : acceleration;
      }
      yield x;
    }
  }
}

class Light extends StatefulWidget {
  static final festiveColors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.white
  ];

  final double x;

  final int period;

  final Color? color;

  Light({
    Key? key,
    required this.x,
  })  : period = 500 + (x.abs() * 4000).floor(),
        color = festiveColors[Random().nextInt(4)],
        super(key: key);

  @override
  _LightState createState() => _LightState();
}

class _LightState extends State<Light> {
  Color _newColor = Colors.white;
  Color color = Light.festiveColors[Random().nextInt(4)];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Align(
        alignment: Alignment(widget.x, 0.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: widget.period),
            tween: ColorTween(begin: widget.color, end: _newColor),
            onEnd: () {
              setState(() {
                _newColor =
                    (_newColor == Colors.white ? widget.color : Colors.white)!;
              });
            },
            builder: (_, color, __) {
              return Container(
                color: Light.festiveColors[Random().nextInt(4)],
              );
            },
          ),
        ),
      ),
    );
  }
}
