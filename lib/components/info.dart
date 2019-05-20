import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ChecklistItem("Add 5 new Cards"),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ChecklistItem("Review Level 1 Cards (5)"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  child: CupertinoButton.filled(
                    child: Text("Get Started"),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
