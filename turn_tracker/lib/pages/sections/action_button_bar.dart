import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


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
  final List<String> buttonTexts;
  final List<TextStyle> buttonStyles;
  final ValueChanged<int> toggleButton;


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      height: screenSize.height*0.10,
      width: screenSize.width,
      child: Container(
        color: Theme.of(context).colorScheme.tertiary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            if (buttonCount > 0)
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onBackground
                  ),
                  onPressed: () {
                    toggleButton(0);
                  },
                  child: Text(
                    buttonTexts[0],
                    style: buttonStyles[0],
                  ),
                ),
              ),

            if (buttonCount > 1)
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onBackground
                  ),
                  onPressed: () {
                    toggleButton(1);
                  },
                  child: Text(
                    buttonTexts[1],
                    style: buttonStyles[1],
                  ),
                ),
              ),

            if (buttonCount > 2)
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onBackground
                  ),
                  onPressed: () {
                    toggleButton(2);
                  },
                  child: Text(
                    buttonTexts[2],
                    style: buttonStyles[2],
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