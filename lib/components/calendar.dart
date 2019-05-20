import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const leitnerDays = {
  1: [2, 1],
  2: [3, 1],
  3: [2, 1],
  4: [4, 1],
  5: [2, 1],
  6: [3, 1],
  7: [2, 1],
  8: [1],
  9: [2, 1],
  10: [3, 1],
  11: [2, 1],
  12: [5, 1],
  13: [4, 2, 1],
  14: [3, 1],
  15: [2, 1],
  16: [1],
  17: [2, 1],
  18: [3, 1],
  19: [2, 1],
  20: [4, 1],
  21: [2, 1],
  22: [3, 1],
  23: [2, 1],
  24: [6, 1],
  25: [2, 1],
  26: [3, 1],
  27: [2, 1],
  28: [5, 1],
  29: [4, 2, 1],
  30: [3, 1],
  31: [2, 1],
  32: [1],
  33: [2, 1],
  34: [3, 1],
  35: [2, 1],
  36: [4, 1],
  37: [2, 1],
  38: [3, 1],
  39: [2, 1],
  40: [1],
  41: [2, 1],
  42: [3, 1],
  43: [2, 1],
  44: [5, 1],
  45: [4, 2, 1],
  46: [3, 1],
  47: [2, 1],
  48: [1],
  49: [2, 1],
  50: [3, 1],
  51: [2, 1],
  52: [4, 1],
  53: [2, 1],
  54: [3, 1],
  55: [2, 1],
  56: [7, 1],
  57: [2, 1],
  58: [3, 1],
  59: [6, 2, 1],
  60: [5, 1],
  61: [4, 2, 1],
  62: [3, 1],
  63: [2, 1],
  64: [1],
};

const colorForLevel = {
  1: Colors.red,
  2: Colors.orange,
  3: Colors.yellow,
  4: Colors.green,
  5: Colors.blue,
  6: Colors.purple,
  7: Colors.pink,
};

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow()],
        color: Colors.white,
      ),
      height: 250,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _generateCalendarDays(),
        ),
      ),
    );
  }

  List<Widget> _generateCalendarDays() {
    final days = List<Widget>();

    for (int i = 1; i <= 64; i++) {
      days.add(_generateDay(i));
    }

    return days;
  }

  Widget _generateDay(int i) {
    final levels = List<Widget>();
    final day = leitnerDays[i];

    for (int j = 7; j > 0; j--) {
      levels.add(
        day.indexOf(j) != -1
            ? Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      j.toString(),
                      style: TextStyle(color: colorForLevel[j]),
                    )),
              )
            : Spacer(),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.0),
          child: Column(
            children: levels,
          ),
        ),
        i == 1
            ? Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                  size: 35.0,
                ),
              )
            : Container(),
      ],
    );
  }
}
