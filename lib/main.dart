import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        barBackgroundColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      ),
      home: HomeScreen(),
    );
  }
}
