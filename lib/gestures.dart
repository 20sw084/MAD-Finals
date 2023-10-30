import 'package:flutter/material.dart';

class Gestures extends StatefulWidget {
  const Gestures({super.key});

  @override
  State<Gestures> createState() => _GesturesState();
}

class _GesturesState extends State<Gestures> {
  double _scale = 1.0;
  // double _prevousScale = 1.0;
  Offset offset = const Offset(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestures"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                print("Just Tapped");
              },
              onDoubleTap: () {
                print("Double Tapped");
              },
              onLongPress: () {
                print("Long Pressed");
              },
              onVerticalDragUpdate: (details){
                print(details.localPosition.dy);
              },
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'Tap me.',
                  ),
                ),
              ),
            ),
            GestureDetector(
              // Optional Method for pinching
              // onScaleStart: (details) {
              //   _prevousScale = _scale;
              // },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = details.scale;
                });
              },
              // Optional Method
              // onScaleEnd: (details) {
              //   setState(() {
              //     _scale = 1.0;
              //   });
              // },
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.blueGrey,
                  child: const Center(
                    child: Text(
                      'Zoom me.',
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx,
                      offset.dy + details.delta.dy); //
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: offset,
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.cyanAccent,
                    child: const Center(
                      child: Text(
                        'Hold me.',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
