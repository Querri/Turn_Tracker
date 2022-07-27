import 'package:flutter/material.dart';

import 'package:spirit_island_app/pages/main_view.dart';

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
        fontSize: 35,
      ),
      headline6: TextStyle(
        color: _colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: _colorScheme.onBackground,
        fontSize: 15,
      ),
      bodyText2: TextStyle(
      color: _colorScheme.onBackground,
      fontSize: 18,
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

const Color brown_dark = Color(0xFF14100D);
const Color brown_medium = Color(0xFF211A15);
const Color brown_light = Color(0xFF875D36);
const Color brown_bright = Color(0xFF754C24);

const Color orange_light = Color(0xFFffccb3);
const Color orange_dark = Color(0xFFffb366);
const Color salmon_light = Color(0xFFff5050);
const Color salmon_dark = Color(0xFFff3333);

const Color night_light = Color(0xFF364156);
const Color night_medium = Color(0xFF212D40);
const Color night_dark = Color(0xFF11151C);
const Color red_light = Color(0xFFEE5C42);
const Color red_bright = Color(0xFFD90429);


const Color green_white = Color(0xFFCAD2C5);
const Color green_light = Color(0xFF84A98C);
const Color green_medium = Color(0xFF52796F);
const Color green_dark = Color(0xFF354F52);
const Color green_black = Color(0xFF2F3E46);


const Color idk_dark = Color(0xFF1E2531);

const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: idk_dark,
  primaryVariant: idk_dark,
  onPrimary: white,

  secondary: red_light,
  secondaryVariant: red_light,
  onSecondary: white,

  background: black,
  onBackground: white,

  error: black,
  onError: white,

  surface: white,
  onSurface: black,
);