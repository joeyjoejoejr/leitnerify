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
  Future<void> setCardsPerDay(int val) async {
    final prefs = await SharedPreferences.getInstance();
    final isSet = await prefs.setInt("cards_per_day", val);
    final reviewCards = await getReviewCards(val: val);
    if (isSet) {
      setState(() {
        _cardsPerDay = val;
        _reviewCards = reviewCards;
      });
    }
  }

  int get cardsAddedToday => _cardsAddedToday;
  set cardsAddedToday(int val) => setState(() => _cardsAddedToday = val);
  int get day => _day;
  DateTime get completedReviewAt => _completedReviewAt;
  List<LeitnerLevel> get reviewCards => _reviewCards;

  TimeOfDay get notificationTime => _notificationTime;
  setNotificationTime(TimeOfDay val) async {
    final hour = val == null ? null : val.hour;
    final minute = val == null ? null : val.minute;
    final prefs = await SharedPreferences.getInstance();
    var didSet = await prefs.setInt('notification_hour', hour);
    didSet = await prefs.setInt('notification_minute', minute);
    if (didSet) setState(() => _notificationTime = val);
  }

  bool get shouldSendNotification => notificationTime != null;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) return Container(color: Colors.white);

    return _AppStateInherited(
      data: this,
      child: widget.child,
    );
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int day = prefs.getInt('day') ?? 1;
    final int cardsPerDay = prefs.getInt('cards_per_day') ?? 5;
    final int cardsAddedToday = await DbProvider.db.queryCardsCreatedToday();
    final DateTime completedReviewAt =
        prefs.getInt('completed_review_at') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                prefs.getInt('completed_review_at'),
              )
            : null;
    final reviewCards = await getReviewCards(val: cardsPerDay, newDay: day);
    final hour = prefs.getInt('notification_hour');
    final minute = prefs.getInt('notification_minute');

    setState(() {
      _cardsPerDay = cardsPerDay;
      _cardsAddedToday = cardsAddedToday;
      _day = day;
      _notificationTime =
          hour != null ? TimeOfDay(hour: hour, minute: minute) : null;
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

  Future<List<LeitnerLevel>> getReviewCards({int val, int newDay}) async {
    List<LeitnerLevel> cards = [];
    final perDay = val != null ? val : cardsPerDay;
    final actualDay = newDay != null ? newDay : day;

    for (int level in leitnerDays[actualDay]) {
      final int count = await DbProvider.db.queryCardCountByLevel(level);

      if (count != 0) {
        cards.add(LeitnerLevel(level, count));
      } else if (level == 1) {
        cards.add(LeitnerLevel(level, count + perDay));
      }
    }
    return cards;
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
