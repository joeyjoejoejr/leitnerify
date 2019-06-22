import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app-state.dart';
import 'checklist-item.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: FittedBox(
          fit: BoxFit.none,
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    final data = App.of(context);
    final children = [
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Today",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: ChecklistItem(
          "Add ${data.cardsPerDay} new Cards",
          checked: data.cardsAddedToday == data.cardsPerDay,
        ),
      ),
    ];

    for (var level in data.reviewCards) {
      children.add(
        Padding(
          padding: EdgeInsets.all(5.0),
          child: ChecklistItem(
              "Review Level ${level.level} Cards (${level.numCards})"),
        ),
      );
    }
    children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          child: CupertinoButton.filled(
            child: Text("Get Started"),
            onPressed: () {
              var cardNumber = data.cardsAddedToday + 1;
              if (data.cardsAddedToday >= data.cardsPerDay) {
                Navigator.pushNamed(
                  context,
                  '/review-cards',
                );
              } else {
                Navigator.pushNamed(
                  context,
                  '/create-card',
                  arguments: cardNumber,
                );
              }
            },
          ),
        ),
      ),
    );

    return children;
  }
}
