import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/screens/review-cards.dart';
import 'package:leiterify/utils/app-state.dart';

class CreationComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = App.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text("Continue"),
          onPressed: () => navigateToReviewCards(context, data.day),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64.0,
            ),
            Text("Done adding cards!"),
          ],
        ),
      ),
    );
  }
}
