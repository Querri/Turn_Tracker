import 'package:flutter/material.dart';

import 'package:spirit_island_app/main_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      home: MainView(),
    );
  }
}

/// Theme for the app.
ThemeData theme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _colorScheme,

    appBarTheme: AppBarTheme(
      color: _colorScheme.primary,
    ),

    backgroundColor: _colorScheme.background,

    buttonTheme: ButtonThemeData(
      focusColor: _colorScheme.secondary,
      buttonColor: _colorScheme.secondary,
      minWidth: 120,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      )
    ),
  );
}

/// Colors and color scheme.
const Color white = Color(0xFFFFFFFF);
const Color alabaster = Color(0xFFF5F1E3);
const Color bone = Color(0xFFDDDBCB);
const Color lightBlue = Color(0xFF7CBBBB);
const Color blue = Color(0xFF1B9AAA);
const Color black = Color(0xFF050505);

const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: blue,
  primaryVariant: lightBlue,
  onPrimary: white,

  secondary: bone,
  secondaryVariant: bone,
  onSecondary: black,

  background: alabaster,
  onBackground: black,

  error: black,
  onError: white,

  surface: white,
  onSurface: black,
);