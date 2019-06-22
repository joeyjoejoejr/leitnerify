import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/create-card.dart';
import 'utils/app-state.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  runApp(App(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final data = App.of(context);
    if (!data.loaded) return Container();

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
              child: CreateCard(
                  cardNumber: cardNumber, totalCards: data.cardsPerDay));
        },
      },
    );
  }
}
