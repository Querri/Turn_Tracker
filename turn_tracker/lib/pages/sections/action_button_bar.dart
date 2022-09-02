import 'package:flutter/material.dart';


/// Button bar visible in main view and game view.
///
/// Contains between 0-3 buttons.
class ActionButtonBar extends StatelessWidget {

  ActionButtonBar({
    Key key,
    @required this.buttonCount,
    @required this.buttonTexts,
    @required this.buttonStyles,
    @required this.toggleButton
  }) : super(key: key);

  final int buttonCount;
  final List<dynamic> buttonTexts;
  final List<dynamic> buttonStyles;
  final ValueChanged<int> toggleButton;


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      height: 90,
      width: screenSize.width,
      child: Container(
        color: Theme.of(context).colorScheme.tertiary,

        child:TextButtonTheme(
          data: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onBackground,
              alignment: Alignment.center,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              if (buttonCount > 0)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      toggleButton(0);
                    },
                    child: Text(
                      buttonTexts[0],
                      style: buttonStyles[0],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              if (buttonCount > 1)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      toggleButton(1);
                    },
                    child: Text(
                      buttonTexts[1],
                      style: buttonStyles[1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              if (buttonCount > 2)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      toggleButton(2);
                    },
                    child: Text(
                      buttonTexts[2],
                      style: buttonStyles[2],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              /*
              if (buttonCount > 0)
                _ActionButton(
                  buttonNum: 0,
                  buttonText: buttonTexts[0],
                  buttonStyle: _getButtonStyle(context, buttonTexts[0], false),
                  toggleButton: _toggleButton,
                ),
              */

            ],
          ),
        ),
      ),
    );
  }
}


/*
/// An action button.
class _ActionButton extends StatelessWidget {

  _ActionButton({
    @required this.buttonNum,
    @required this.buttonText,
    @required this.buttonStyle,
    @required this.toggleButton
  });

  final int buttonNum;
  final String buttonText;
  final TextStyle buttonStyle;
  final ValueChanged<int> toggleButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.onBackground
        ),
        onPressed: () {
          toggleButton(buttonNum);
        },
        child: Text(
          buttonText,
          style: buttonStyle,
        ),
      ),
    );
  }
}
 */