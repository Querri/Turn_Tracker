import 'package:flutter/material.dart';
import 'package:spirit_island_app/pages/sections/action_button_bar.dart';


/// Section for a player.
///
/// Player 0 is right way up and player 1 is upside down.
class PlayerSectionSymmetric extends StatelessWidget {
  PlayerSectionSymmetric({this.turnTracker, this.playerNum,
    @required this.toggleAction});
  final turnTracker;
  final playerNum;
  final ValueChanged<List<int>> toggleAction;


  /// Add playerNum to toggleAction function call.
  void _toggleActionButton(int buttonNum) {
    toggleAction([playerNum, buttonNum]);
  }


  /// Get rotation value for each player.
  ///
  /// Used to rotate player 1 180 degrees.
  int _getRotation(playerNum) {
    if (playerNum == 1) return 2;
    else return 0;
  }


  /// Get style for a button depending on its state.
  List<TextStyle> _getActionButtonStyles(context, actionButtonCount, playerNum) {
    List<TextStyle> textStyles = [];
    for (int i=0; i<actionButtonCount; i++) {
      if (turnTracker.isActionAvailable(i)) {
        if (turnTracker.isActionDone(playerNum, i)) {
          textStyles.add(Theme.of(context).textTheme.labelSmall
              .copyWith(color: Theme.of(context).colorScheme.onBackground));
        } else {
          textStyles.add(Theme.of(context).textTheme.labelMedium
              .copyWith(color: Theme.of(context).colorScheme.primary));
        }
      }
    }
    return textStyles;
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final actionButtonCount = turnTracker.getNumberOfActions();


    return SizedBox(
      height: screenSize.height / 2 - screenSize.width * 0.4,
      child: RotatedBox(
        quarterTurns: _getRotation(playerNum),
        child: Stack(
          children: [
            Positioned(
              bottom: 96,
              width: screenSize.width,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Text(
                    turnTracker.getPhaseText(),
                    key: ValueKey<String>(turnTracker.getPhaseText()),
                    style: Theme.of(context).textTheme.headlineLarge
                ),
              ),
            ),

            /// Orange line above button row
            Positioned(
              bottom: 90,
              left: 0,
              height: 6,
              width: screenSize.width,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            /// Button row
            ActionButtonBar(
              buttonCount: actionButtonCount,
              buttonTexts: turnTracker.getActionText(),
              buttonStyles: _getActionButtonStyles(context, actionButtonCount, playerNum),
              toggleButton: _toggleActionButton,
            ),
          ],
        ),

      ),
    );
  }
}