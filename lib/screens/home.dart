import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/calendar.dart';
import '../components/info.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Leitnerify"),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Info(), Calendar()],
        ),
      ),
    );
  }
}
