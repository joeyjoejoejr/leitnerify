import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/utils/platform.dart';

class CupertinoDateInput extends StatefulWidget {
  final TimeOfDay initialTime;
  CupertinoDateInput({@required this.initialTime});

  @override
  State<StatefulWidget> createState() => CupertinoDateInputState();
}

class CupertinoDateInputState extends State<CupertinoDateInput> {
  DateTime _selectedTime;
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CupertinoDateInput old) {
    super.didUpdateWidget(old);
    if (old.initialTime != widget.initialTime) {
      _init();
    }
  }

  void _init() {
    final now = DateTime.now();
    _selectedTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.initialTime.hour,
      widget.initialTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: CupertinoColors.white,
          child: Align(
            alignment: Alignment.centerRight,
            child: PlatformFlatButton(
              onPressed: () => Navigator.pop(
                    context,
                    TimeOfDay(
                      hour: _selectedTime.hour,
                      minute: _selectedTime.minute,
                    ),
                  ),
              child: Text("Done"),
            ),
          ),
        ),
        Container(
          height: media.copyWith().size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: _selectedTime,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (val) => _selectedTime = val,
          ),
        )
      ],
    );
  }
}
