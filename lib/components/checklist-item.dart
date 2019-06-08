import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChecklistItem extends StatelessWidget {
  final String text;

  ChecklistItem(String text) : this.text = text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_box_outline_blank,
          color: CupertinoColors.black,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(text),
        ),
      ],
    );
  }
}
