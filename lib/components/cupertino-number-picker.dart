import 'package:flutter/cupertino.dart';
import 'package:leiterify/utils/platform.dart';

class CupertinoNumberPicker extends StatelessWidget {
  final int start;
  final int end;

  CupertinoNumberPicker({this.start = 0, this.end = 20});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      height: media.copyWith().size.height / 3,
      child: CupertinoActionSheet(
        actions: _getRange()
            .map((i) => PlatformFlatButton(
                  child: Text(i.toString()),
                  onPressed: () {
                    Navigator.pop(context, i);
                  },
                ))
            .toList(),
      ),
    );
  }

  Iterable<int> _getRange() {
    return Iterable.generate(end - start + 1, (i) => i + start);
  }
}
