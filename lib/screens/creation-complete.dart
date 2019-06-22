import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreationComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text("Continue"),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/review-cards',
            );
          },
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
