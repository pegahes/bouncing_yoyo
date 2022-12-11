import 'package:bouncing_yoyo/page_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'instance.dart';
import 'square_detail.dart';

void main() {
  setupInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bouncing YoYo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const BackScreen(),
    );
  }
}

class BackScreen extends StatefulWidget {
  const BackScreen({Key? key}) : super(key: key);

  @override
  State<BackScreen> createState() => _BackScreenState();
}

class _BackScreenState extends State<BackScreen> {
  final pageManager = getIt<PageManager>();
  final double _squareSize = 60;
  double _slope = 0;
  double _xDistance = 0;
  int _swipeCount = 0;

  @override
  void initState() {
    super.initState();
  }

  void moveRight(double slope, int count) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_swipeCount != count) {
        timer.cancel();
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      pageManager.setSquarePosition(Offset(
          pageManager.squarePosition.value!.dx + _xDistance,
          pageManager.squarePosition.value!.dy - slope * _xDistance));

      if (pageManager.squarePosition.value!.dy < 0 ||
          pageManager.squarePosition.value!.dy >
              MediaQuery.of(context).size.height - _squareSize) {
        timer.cancel();
        moveRight(-slope, count);
      }

      if (pageManager.squarePosition.value!.dx >
          MediaQuery.of(context).size.width - _squareSize) {
        timer.cancel();
        moveLeft(-slope, count);
      }
    });
  }

  void moveLeft(double slope, int count) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_swipeCount != count) {
        timer.cancel();
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      pageManager.setSquarePosition(Offset(
          pageManager.squarePosition.value!.dx - _xDistance,
          pageManager.squarePosition.value!.dy + slope * _xDistance));

      if (pageManager.squarePosition.value!.dy < 0 ||
          pageManager.squarePosition.value!.dy >
              MediaQuery.of(context).size.height - _squareSize) {
        timer.cancel();
        moveLeft(-slope, count);
      }
      if (pageManager.squarePosition.value!.dx < 0) {
        timer.cancel();
        moveRight(-slope, count);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pageManager.squarePosition.value ??= Offset(
        (MediaQuery.of(context).size.width - _squareSize) / 2,
        (MediaQuery.of(context).size.height - _squareSize) / 2);

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              _swipeCount++;
              _slope = (-details.globalPosition.dy +
                      pageManager.squarePosition.value!.dy) /
                  (details.globalPosition.dx -
                      pageManager.squarePosition.value!.dx);
              if (details.globalPosition.dx <
                  pageManager.squarePosition.value!.dx) {
                moveLeft(_slope, _swipeCount);
              }
              if (details.globalPosition.dx >
                  pageManager.squarePosition.value!.dx) {
                moveRight(_slope, _swipeCount);
              }
            },
            onTap: () {
              pageManager.changeImage();
            },
          ),
          ValueListenableBuilder<Offset?>(
              valueListenable: pageManager.squarePosition,
              builder: (_, offset, __) {
                return Positioned(
                  left: offset!.dx,
                  top: offset.dy,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      shape: BoxShape.rectangle,
                    ),
                    height: _squareSize,
                    width: _squareSize,
                    child: const SquareDetailWidget(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
