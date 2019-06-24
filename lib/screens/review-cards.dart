import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/database.dart';
import 'package:leiterify/utils/card-painter.dart';
import 'package:leiterify/utils/drawing-elements.dart';

import '../models/models.dart' as models;

class ReviewCardsArguments {
  final models.Card card;

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
    final front = args.card.frontSide;
    List<DrawingElement> paintElements = List.from(front.elements);
    if (front.image != null) {
      paintElements.insert(0, BackgroundImage(front.image));
    }
    if (front.backgroundFill != null) {
      paintElements.insert(0, Fill(front.backgroundFill));
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Reviewing Level ${args.card.level} Cards"),
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 100.0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Visibility(
            child: Text("Front"),
          ),
          Container(
            height: 300.0,
            color: Colors.white,
            child: Stack(children: [
              CustomPaint(
                painter: CardPainter(paintElements),
                size: Size.infinite,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: AutoSizeText(
                    front.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: front.textColor, fontSize: 32.0),
                    maxLines: 2,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
