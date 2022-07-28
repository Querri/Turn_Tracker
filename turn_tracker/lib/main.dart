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
const Color black = Color(0xFF050505);

const Color grey_1 = Color(0xFF0D1319); // primary
const Color grey_2 = Color(0xFF151E27); // background

const Color grey_3 = Color(0xFF334551); // secondaryVariant
const Color orange = Color(0xFFCC7636); // secondary


const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: grey_1,
  primaryVariant: grey_1,
  onPrimary: white,

  secondary: orange,
  secondaryVariant: grey_3,
  onSecondary: white,

  background: grey_2,
  onBackground: grey_3,

  error: black,
  onError: white,

  surface: white,
  onSurface: black,
);