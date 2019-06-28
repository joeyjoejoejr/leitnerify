import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/database.dart';
import 'package:leiterify/utils/app-state.dart';
import 'package:leiterify/utils/card-painter.dart';
import 'package:leiterify/utils/drawing-elements.dart';
import 'package:leiterify/utils/platform.dart';

import '../models/models.dart' as models;

class ReviewCardsArguments {
  final models.Card card;
  bool replace = false;

  ReviewCardsArguments({@required this.card, this.replace});
}

void navigateToReviewCards(BuildContext context, int day,
    {bool first = false}) async {
  final card = await DbProvider.db.queryNextCardByDay(day);
  final state = App.of(context);

  if (card != null && first) {
    Navigator.pushNamed(
      context,
      '/review-cards',
      arguments: ReviewCardsArguments(card: card),
    );
  } else if (card != null) {
    Navigator.pushReplacementNamed(
      context,
      '/review-cards',
      arguments: ReviewCardsArguments(card: card, replace: true),
    );
  } else {
    await state.completeReview();
    Navigator.pushReplacementNamed(
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
    print("Route: ${ModalRoute.of(context).settings}");
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

    return PlatformScaffold(
      navigationBar: PlatformAppBar(
        title: Text("Reviewing Level ${card.level} Cards"),
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 100.0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Visibility(
            child: Text(sideName),
          ),
          AspectRatio(
            aspectRatio: 5.0 / 3.0,
            child: Container(
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
                      style: TextStyle(
                          color: currentSide.textColor, fontSize: 32.0),
                      maxLines: 2,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: currentSide.id == card.frontSide.id
                ? _getFrontBar(card)
                : _getBackBar(context, card),
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

  Widget _getBackBar(BuildContext context, models.Card card) {
    final state = App.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            int level = card.level;
            card.promote();
            await DbProvider.db.updateCard(card);
            final numInLevel = await DbProvider.db.queryCardCountByLevel(level);
            if (numInLevel == 0) {
              state.completeLevel(level);
            }
            navigateToReviewCards(context, state.day);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5.0),
              color: Colors.white,
            ),
            child: Icon(
              Icons.thumb_up,
              color: Colors.green,
              size: 32.0,
            ),
          ),
        ),
        Container(
          width: 37.0,
        ),
        GestureDetector(
          onTap: () async {
            card.level = 1;
            await DbProvider.db.updateCard(card);
            navigateToReviewCards(context, state.day);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5.0),
              color: Colors.white,
            ),
            child: Icon(
              Icons.thumb_down,
              color: Colors.red,
              size: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}
