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
      color: _colorScheme.tertiary,
    ),

    backgroundColor: _colorScheme.background,

    textTheme: TextTheme(
      /// Phase text
      headlineLarge: TextStyle(
        color: _colorScheme.onBackground,
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),

      headlineMedium: TextStyle(
        color: _colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),

      /// active button
      labelMedium: TextStyle(
        color: _colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),

      /// inactive button
      labelSmall: TextStyle(
        color: _colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),

      /// random text
      bodySmall: TextStyle(
        color: _colorScheme.onBackground,
        fontSize: 18,
      ),
    ),


    buttonTheme: ButtonThemeData(
      focusColor: _colorScheme.secondary,
      buttonColor: _colorScheme.secondary,
      minWidth: 120,
      height: 150,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      )
    ),
  );
}

/// Colors and a color scheme.
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF050505);

const Color grey_1 = Color(0xFF0D1319); // primary
const Color grey_2 = Color(0xFF1B2630); // background

const Color grey_3 = Color(0xFF334551); // secondaryVariant
const Color orange = Color(0xFFCC7636); // secondary


const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: orange,
  onPrimary: orange,

  secondary: grey_3,
  onSecondary: grey_3,

  tertiary: grey_1,

  background: grey_2,
  onBackground: grey_3,

  surface: white,
  onSurface: black,

  error: black,
  onError: white,

);
