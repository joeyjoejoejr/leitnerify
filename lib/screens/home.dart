import 'package:flutter/cupertino.dart';
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
        trailing: PlatformIconButton(
          iosIcon: Icon(CupertinoIcons.settings, size: 28.0),
          androidIcon: Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, "/settings"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Info(), Calendar()],
      ),
    );
  }
}
