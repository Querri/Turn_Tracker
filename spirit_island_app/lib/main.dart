import 'package:flutter/material.dart';

import 'file:///E:/SlowProjects/2021_Other/Spirit_Island_App/spirit_island_app/lib/pages/main_view.dart';

void main() {
  runApp(MyApp());
}


/// Root of the application.
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turn Tracker',
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

    textTheme: TextTheme(
      headline4: TextStyle(
        color: _colorScheme.onBackground,
        fontWeight: FontWeight.bold,
        fontFamily: 'Josefin Sans'
      ),
      headline6: TextStyle(
        color: _colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: _colorScheme.onBackground,
      )
    ),

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

/// Colors and a color scheme.
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