import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/calendar.dart';

class App extends StatefulWidget {
  final Widget child;
  App({this.child});

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_AppStateInherited)
            as _AppStateInherited)
        .data;
  }
}

class AppState extends State<App> {
  int _cardsPerDay;
  int _cardsAddedToday;
  int _day;
  TimeOfDay _notificationTime;
  DateTime _completedReviewAt;
  List<LeitnerLevel> _reviewCards;

  bool _loaded = false;
  bool get loaded => _loaded;

  int get cardsPerDay => _cardsPerDay;
  int get cardsAddedToday => _cardsAddedToday;
  set cardsAddedToday(int val) => setState(() => _cardsAddedToday = val);
  int get day => _day;
  DateTime get completedReviewAt => _completedReviewAt;
  List<LeitnerLevel> get reviewCards => _reviewCards;

  TimeOfDay get notificationTime => _notificationTime;
  set notificationTime(TimeOfDay val) =>
      setState(() => _notificationTime = val);

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateInherited(
      data: this,
      child: widget.child,
    );
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: Remove this
    prefs.clear();
    final int day = prefs.getInt('day') ?? 1;
    final int cardsPerDay = prefs.getInt('cards_per_day') ?? 5;
    final int cardsAddedToday = await DbProvider.db.queryCardsCreatedToday();
    final DateTime completedReviewAt =
        prefs.getInt('completed_review_at') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                prefs.getInt('completed_review_at'),
              )
            : null;

    List<LeitnerLevel> reviewCards = [];
    for (int level in leitnerDays[day]) {
      final int count = await DbProvider.db.queryCardCountByLevel(level);

      if (count != 0) {
        reviewCards.add(LeitnerLevel(level, count));
      } else if (level == 1) {
        reviewCards.add(LeitnerLevel(level, count + cardsPerDay));
      }
    }

    setState(() {
      _cardsPerDay = cardsPerDay;
      _cardsAddedToday = cardsAddedToday;
      _day = day;
      _notificationTime = TimeOfDay(
        hour: prefs.getInt('notification_hour') ?? 17,
        minute: prefs.getInt('notification_minute') ?? 0,
      );
      _completedReviewAt = completedReviewAt;
      _reviewCards = reviewCards;
      _loaded = true;
    });
  }

  completeReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final date = DateTime.now();
    await prefs.setInt('day', day + 1);
    await prefs.setInt('completed_review_at', date.millisecondsSinceEpoch);
    setState(() {
      _completedReviewAt = date;
      _day = day + 1;
    });
  }

  void completeLevel(int level) {
    _reviewCards.firstWhere((l) => level == l.level).isComplete = true;
  }
}

class _AppStateInherited extends InheritedWidget {
  final AppState data;
  _AppStateInherited({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AppStateInherited old) => true;
}

class LeitnerLevel {
  int level;
  int numCards;
  bool isComplete = false;
  LeitnerLevel(this.level, this.numCards);
}
