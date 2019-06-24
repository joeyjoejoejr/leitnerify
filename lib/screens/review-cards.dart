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

class ReviewCards extends StatefulWidget {
  ReviewCardsState createState() => ReviewCardsState();
}

class ReviewCardsState extends State<ReviewCards> {
  models.Side currentSide;
  String sideName = "Front";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ReviewCardsArguments args = ModalRoute.of(context).settings.arguments;
    currentSide = args.card.frontSide;
  }

  @override
  Widget build(BuildContext context) {
    final ReviewCardsArguments args = ModalRoute.of(context).settings.arguments;
    final card = args.card;

    List<DrawingElement> paintElements = List.from(currentSide.elements);
    if (currentSide.image != null) {
      paintElements.insert(0, BackgroundImage(currentSide.image));
    }
    if (currentSide.backgroundFill != null) {
      paintElements.insert(0, Fill(currentSide.backgroundFill));
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Reviewing Level ${card.level} Cards"),
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 100.0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Visibility(
            child: Text(sideName),
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
                    currentSide.text,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: currentSide.textColor, fontSize: 32.0),
                    maxLines: 2,
                  ),
                ),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: currentSide.id == card.frontSide.id
                ? _getFrontBar(card)
                : _getFrontBar(card),
          ),
        ],
      ),
    );
  }

  Widget _getFrontBar(models.Card card) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() {
                currentSide = card.backSide;
                sideName = "Back";
              }),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5.0),
              color: Colors.white,
            ),
            child: Icon(
              Icons.replay,
              color: Colors.black,
              size: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}
