import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/utils/app-state.dart';
import 'package:leiterify/utils/platform.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = App.of(context);
    return PlatformScaffold(
      navigationBar: PlatformAppBar(
        leading: PlatformFlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            _getCardsPerDayInput(context),
            _getSendNotifications(context),
            data.shouldSendNotification
                ? _getNotificationTimeInput(context)
                : null,
          ].where((item) => item != null).toList(),
        ),
      ),
    );
  }

  Widget _getCardsPerDayInput(BuildContext context) {
    final data = App.of(context);
    return Material(
      child: ListTile(
        title: Text("Number of Cards To Add Per Day"),
        trailing: SizedBox(
          width: 40.0,
          child: PlatformNumberPicker(
            placeholder: data.cardsPerDay.toString(),
            onSubmitted: (int val) {
              if (val != null) data.setCardsPerDay(val);
            },
          ),
        ),
      ),
    );
  }

  Widget _getSendNotifications(BuildContext context) {
    final data = App.of(context);
    return Material(
      child: ListTile(
        title: Text("Send Notification"),
        trailing: PlatformSwitch(
          value: data.shouldSendNotification,
          onChanged: (bool onoroff) async {
            final now = DateTime.now();
            if (onoroff) {
              await data.setNotificationTime(TimeOfDay(
                hour: now.hour,
                minute: now.minute,
              ));
            } else {
              await data.setNotificationTime(null);
            }
          },
        ),
      ),
    );
  }

  Widget _getNotificationTimeInput(BuildContext context) {
    final data = App.of(context);
    return Material(
      child: ListTile(
        title: Text("Notification Time"),
        trailing: SizedBox(
          width: 80.0,
          child: PlatformDatePicker(
            onSubmitted: (val) {
              if (val != null) {
                data.setNotificationTime(TimeOfDay(
                  hour: val.hour,
                  minute: val.minute,
                ));
              }
            },
            initial: data.notificationTime,
          ),
        ),
      ),
    );
  }
}
