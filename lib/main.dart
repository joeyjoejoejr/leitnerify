import 'package:flutter/material.dart';
import 'package:leiterify/screens/review-cards.dart';
import 'package:leiterify/screens/settings.dart';
import 'package:leiterify/utils/platform.dart';

import 'screens/home.dart';
import 'screens/create-card.dart';
import 'screens/creation-complete.dart';
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

    return PlatformApp(
      home: HomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/create-card':
            final Map<String, dynamic> args = settings.arguments;
            final transition = args["replace"] == true
                ? _getFadeTransition
                : _getSlideTransition;

            return PageRouteBuilder(
              pageBuilder: (BuildContext context, _anim1, _anim2) {
                return Container(
                  child: CreateCard(
                    cardNumber: args["cardNumber"],
                    totalCards: data.cardsPerDay,
                  ),
                );
              },
              transitionsBuilder: transition,
            );
          case '/creation-complete':
            return PageRouteBuilder(
              pageBuilder: (BuildContext context, _anim1, _anim2) {
                return Container(
                  child: CompleteScreen(
                    completeText: Text("Done Creating Cards!"),
                    next: () =>
                        navigateToReviewCards(context, App.of(context).day),
                  ),
                );
              },
              transitionsBuilder: _getSlideTransition,
            );
          case '/review-cards':
            final ReviewCardsArguments args = settings.arguments;
            final transition =
                args.replace ? _getFadeTransition : _getSlideTransition;
            return PageRouteBuilder(
              settings: RouteSettings(arguments: args),
              pageBuilder: (BuildContext context, _anim1, _anim2) {
                return Container(child: ReviewCards());
              },
              transitionsBuilder: transition,
            );
          case '/review-complete':
            return PageRouteBuilder(
              pageBuilder: (BuildContext context, _anim1, _anim2) {
                return CompleteScreen(
                  completeText: Text("Done Reviewing Cards!"),
                );
              },
              transitionsBuilder: _getSlideTransition,
            );
          case '/settings':
            return PageRouteBuilder(
                pageBuilder: (BuildContext context, _anim1, _anim2) {
                  return SettingsScreen();
                },
                transitionsBuilder: (ctx, an, an1, child) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(an),
                      child: child,
                    ));
        }
      },
    );
  }

  Widget _getSlideTransition(
    BuildContext context,
    Animation<double> anim,
    Animation<double> anim1,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    );
  }

  Widget _getFadeTransition(
    BuildContext context,
    Animation<double> anim,
    Animation<double> anim1,
    Widget child,
  ) {
    return FadeTransition(
      opacity: anim,
      child: child,
    );
  }
}
