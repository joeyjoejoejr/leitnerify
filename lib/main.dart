import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/create-card.dart';

void main() async {
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
      routes: {
        '/create-card': (BuildContext context) {
          final cardNumber = ModalRoute.of(context).settings.arguments;
          return Container(
              child: CreateCard(cardNumber: cardNumber, totalCards: 5));
        },
      },
    );
  }
}
