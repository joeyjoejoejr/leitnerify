import 'package:flutter/material.dart';
import 'package:leiterify/utils/platform.dart';

import '../components/calendar.dart';
import '../components/info.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      navigationBar: PlatformAppBar(
        title: Text("Leitnerify"),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Info(), Calendar()],
      ),
    );
  }
}
