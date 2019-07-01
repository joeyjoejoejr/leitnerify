import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leiterify/components/cupertino-date-input.dart';
import 'dart:io' show Platform;

import 'package:leiterify/components/cupertino-number-picker.dart';

abstract class PlatformWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return createIosWidget(context);
    }
    return null;
  }

  I createIosWidget(BuildContext context);
  A createAndroidWidget(BuildContext context);
}

class PlatformAppBar extends PlatformWidget<CupertinoNavigationBar, AppBar> {
  final Widget leading;
  final Widget title;
  final Widget trailing;
  PlatformAppBar({this.leading, this.title, this.trailing});

  @override
  CupertinoNavigationBar createIosWidget(BuildContext context) =>
      CupertinoNavigationBar(
        leading: leading,
        middle: title,
        trailing: trailing,
      );

  @override
  AppBar createAndroidWidget(BuildContext context) => AppBar(
        leading: leading,
        title: title,
        actions: trailing != null ? [trailing] : null,
      );
}

class PlatformApp extends PlatformWidget<CupertinoApp, MaterialApp> {
  final Widget home;
  final Map<String, WidgetBuilder> routes;
  final void Function(RouteSettings settings) onGenerateRoute;
  PlatformApp({this.home, this.routes, this.onGenerateRoute});

  @override
  CupertinoApp createIosWidget(BuildContext context) => CupertinoApp(
        home: home,
        onGenerateRoute: this.onGenerateRoute,
        theme: CupertinoThemeData(
          barBackgroundColor: CupertinoColors.white,
          scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      );

  @override
  MaterialApp createAndroidWidget(BuildContext context) => MaterialApp(
        home: home,
        onGenerateRoute: onGenerateRoute,
      );
}

class PlatformScaffold extends PlatformWidget<CupertinoPageScaffold, Scaffold> {
  final PlatformAppBar navigationBar;
  final Widget child;
  PlatformScaffold({
    @required this.navigationBar,
    @required this.child,
  });

  @override
  CupertinoPageScaffold createIosWidget(BuildContext context) =>
      CupertinoPageScaffold(
        navigationBar: navigationBar.createIosWidget(context),
        child: child,
      );

  @override
  Scaffold createAndroidWidget(BuildContext context) => Scaffold(
        appBar: navigationBar.createAndroidWidget(context),
        body: child,
      );
}

class PlatformFlatButton extends PlatformWidget<CupertinoButton, FlatButton> {
  final EdgeInsets padding;
  final Widget child;
  final void Function() onPressed;
  PlatformFlatButton({this.padding, this.child, this.onPressed});

  @override
  CupertinoButton createIosWidget(BuildContext context) => CupertinoButton(
        padding: padding,
        child: child,
        onPressed: onPressed,
      );

  @override
  FlatButton createAndroidWidget(BuildContext context) => FlatButton(
        padding: padding,
        child: child,
        onPressed: onPressed,
      );
}

class PlatformRaisedButton
    extends PlatformWidget<CupertinoButton, RaisedButton> {
  final Widget child;
  final void Function() onPressed;
  PlatformRaisedButton({this.child, this.onPressed});

  @override
  CupertinoButton createIosWidget(BuildContext context) =>
      CupertinoButton.filled(
        child: child,
        onPressed: onPressed,
      );

  @override
  RaisedButton createAndroidWidget(BuildContext context) => RaisedButton(
        child: child,
        onPressed: onPressed,
      );
}

class PlatformTextField extends PlatformWidget<CupertinoTextField, TextField> {
  final bool autofocus;
  final String placeholder;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  PlatformTextField({
    this.autofocus = false,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.keyboardType = TextInputType.number,
  });

  @override
  CupertinoTextField createIosWidget(BuildContext context) =>
      CupertinoTextField(
        autofocus: autofocus,
        placeholder: placeholder,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      );

  @override
  TextField createAndroidWidget(BuildContext context) => TextField(
        autofocus: autofocus,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(labelText: placeholder),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      );
}

class PlatformIconButton extends PlatformWidget<CupertinoButton, IconButton> {
  final Icon iosIcon;
  final Icon androidIcon;
  final void Function() onPressed;
  PlatformIconButton({
    @required this.iosIcon,
    @required this.androidIcon,
    @required this.onPressed,
  });

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0.0),
      child: iosIcon,
      onPressed: onPressed,
    );
  }

  @override
  IconButton createAndroidWidget(BuildContext context) {
    return IconButton(
      icon: androidIcon,
      onPressed: onPressed,
    );
  }
}

class PlatformNumberPicker extends PlatformWidget<Widget, TextField> {
  final String placeholder;
  final void Function(int val) onSubmitted;

  PlatformNumberPicker({this.placeholder, @required this.onSubmitted});
  @override
  Widget createIosWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () async {
          final val = await showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoNumberPicker(),
          );
          onSubmitted(val);
        },
        child: Text(placeholder),
      ),
    );
  }

  @override
  TextField createAndroidWidget(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: placeholder),
      keyboardType: TextInputType.number,
      onSubmitted: (String val) => onSubmitted(int.tryParse(val)),
    );
  }
}

class PlatformDatePicker extends PlatformWidget<Widget, Widget> {
  final TimeOfDay initial;
  final void Function(TimeOfDay val) onSubmitted;

  PlatformDatePicker({@required this.initial, @required this.onSubmitted});
  @override
  Widget createIosWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () async {
          final val = await showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoDateInput(
                  initialTime: initial,
                ),
          );
          onSubmitted(val);
        },
        child: Text(initial.format(context)),
      ),
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () async {
          final val = await showTimePicker(
            context: context,
            initialTime: initial,
            builder: (BuildContext context, Widget child) => Theme(
                  data: ThemeData.dark(),
                  child: child,
                ),
          );
          onSubmitted(val);
        },
        child: Text(initial.format(context)),
      ),
    );
  }
}

class PlatformSwitch extends PlatformWidget<CupertinoSwitch, Switch> {
  final bool value;
  final void Function(bool onoroff) onChanged;

  PlatformSwitch({@required this.onChanged, @required this.value});

  @override
  CupertinoSwitch createIosWidget(BuildContext context) {
    return CupertinoSwitch(
      onChanged: onChanged,
      value: value,
    );
  }

  @override
  Switch createAndroidWidget(BuildContext context) {
    return Switch(
      onChanged: onChanged,
      value: value,
    );
  }
}
