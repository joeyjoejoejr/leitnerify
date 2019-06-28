import 'package:flutter/material.dart';
import 'package:leiterify/utils/platform.dart';

import '../utils/app-state.dart';
import '../screens/review-cards.dart';
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
    final isDoneToday = data.completedReviewAt != null ??
        data.completedReviewAt.difference(DateTime.now()).inDays == 0;
    final children = [
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Today",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.0,
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
            "Review Level ${level.level} Cards (${level.numCards})",
            checked: isDoneToday || level.isComplete,
          ),
        ),
      );
    }
    children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          child: isDoneToday
              ? PlatformRaisedButton(
                  child: Text("Done For Today"),
                  onPressed: null,
                )
              : PlatformRaisedButton(
                  child: Text("Get Started"),
                  onPressed: () {
                    var cardNumber = data.cardsAddedToday + 1;
                    if (data.cardsAddedToday >= data.cardsPerDay) {
                      navigateToReviewCards(context, data.day, first: true);
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/create-card',
                        arguments: {"cardNumber": cardNumber},
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
