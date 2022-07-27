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

const Color green_1 = Color(0xFF0C1D23);
const Color green_2 = Color(0xFF132933);
const Color green_3 = Color(0xFF355053);
const Color green_4 = Color(0xFF52796F);
const Color green_5 = Color(0xFF63A893);

const Color blue_1 = Color(0xFF0D1319);
const Color blue_2 = Color(0xFF151E27);
const Color blue_3 = Color(0xFF334551);
const Color blue_4 = Color(0xFF557D8E);
const Color blue_5 = Color(0xFF5E93A5);

const Color brown_1 = Color(0xFF160E0A);
const Color brown_2 = Color(0xFF261B14);
const Color brown_3 = Color(0xFF70543F);
const Color brown_4 = Color(0xFFCE936B);
const Color brown_5 = Color(0xFFCC7636);


const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: blue_1,
  primaryVariant: blue_1,
  onPrimary: blue_5,

  secondary: blue_1,
  secondaryVariant: blue_1,
  onSecondary: blue_3,

  background: blue_2,
  onBackground: blue_5,

  error: black,
  onError: white,

  surface: white,
  onSurface: black,
);