import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

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
  PlatformScaffold({this.navigationBar, this.child});

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

  PlatformTextField({
    this.autofocus,
    this.placeholder,
    this.controller,
    this.onChanged,
  });

  @override
  CupertinoTextField createIosWidget(BuildContext context) =>
      CupertinoTextField(
        autofocus: autofocus,
        placeholder: placeholder,
        controller: controller,
        onChanged: onChanged,
      );

  @override
  TextField createAndroidWidget(BuildContext context) => TextField(
        autofocus: autofocus,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: placeholder),
      );
}
