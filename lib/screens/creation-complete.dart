import 'package:flutter/material.dart';
import 'package:leiterify/utils/platform.dart';

class CompleteScreen extends StatelessWidget {
  final Widget completeText;
  final void Function() next;
  CompleteScreen({@required this.completeText, this.next});

  @override
  Widget build(BuildContext context) {
    final nextButton = next != null ? _getButton(context) : null;

    return PlatformScaffold(
      navigationBar: PlatformAppBar(trailing: nextButton),
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

  Widget _getButton(context) {
    return PlatformFlatButton(
      padding: EdgeInsets.zero,
      child: Text("Continue"),
      onPressed: next,
    );
  }
}
