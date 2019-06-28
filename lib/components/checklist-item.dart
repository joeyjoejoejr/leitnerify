import 'package:flutter/material.dart';

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool checked;

  ChecklistItem(this.text, {this.checked = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          checked ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.black,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(text),
        ),
      ],
    );
  }
}
