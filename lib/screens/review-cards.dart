import 'package:flutter/cupertino.dart';
import 'package:leiterify/database.dart';

import '../models/models.dart';

class ReviewCardsArguments {
  final Card card;

  ReviewCardsArguments(this.card);
}

void navigateToReviewCards(BuildContext context, int day) async {
  final card = await DbProvider.db.queryNextCardByDay(day);
  if (card != null) {
    Navigator.pushNamed(
      context,
      '/review-cards',
      arguments: ReviewCardsArguments(card),
    );
  } else {
    Navigator.pushNamed(
      context,
      '/review-complete',
    );
  }
}

class ReviewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ReviewCardsArguments args = ModalRoute.of(context).settings.arguments;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Reviewing Level ${args.card.level} Cards"),
      ),
      child: Container(),
    );
  }
}
