import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'package:spirit_island_app/pages/game_view_animator.dart';
import 'package:spirit_island_app/pages/sections/action_button_bar.dart';
import 'package:spirit_island_app/turn_tracker.dart';
import 'package:spirit_island_app/models/game.dart';


/// View that is displayed while playing.
///
/// Contains turn tracker, which is customized according
/// to selected game and the number of players.
class GameView extends StatefulWidget {
  final Game game;
  final int playerCount;

  GameView({Key key, @required this.game, @required this.playerCount}) :super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  /// Create turn tracker.
  TurnTracker _turnTracker = new TurnTracker();

  /// Toggle ready button and check if all players are ready.
  void _toggleReady(playerNum) {
    setState(() {
      if (playerNum < 0) {
        // Skip to previous or next phase.
        _turnTracker.changePhase(playerNum);

      } else {
        _turnTracker.toggleReadiness(playerNum);

        if (_turnTracker.isPlayerReady(null)) {
          _turnTracker.changePhase(1);
        }
      }
    });
  }

  /// Toggle action button.
  ///
  /// playerAction[0] is player number and [1] is action button number.
  void _toggleAction(List<int> playerAction) {
    if (_turnTracker.isActionAvailable(playerAction[1])) {
      setState(() {
        _turnTracker.toggleAction(playerAction[0], playerAction[1]);
      });
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (!_turnTracker.initDone) {
      _turnTracker.init(widget.game, widget.playerCount);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (widget.playerCount == 1)
              Container(
                height: screenSize.height*0.5,
              ),
            if (widget.playerCount == 2)
              PlayerSection(
                turnTracker: _turnTracker,
                playerNum: 1,
                toggleReady: _toggleReady,
                toggleAction: _toggleAction,
              ),
            PlayerSection(
              turnTracker: _turnTracker,
              playerNum: 0,
              toggleReady: _toggleReady,
              toggleAction: _toggleAction,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // Enable full screen.
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive
    );
    super.initState();
  }

  @override
  void dispose() {
    // Disable full screen.
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}


/// Section for a player.
///
/// Player 0 is right way up and player 1 is upside down.
class PlayerSection extends StatelessWidget {
  PlayerSection({this.turnTracker, this.playerNum,
    @required this.toggleReady, @required this.toggleAction});
  final turnTracker;
  final playerNum;
  final ValueChanged<int> toggleReady;
  final ValueChanged<List<int>> toggleAction;


  /// Add playerNum to toggleAction function call.
  void _toggleActionButton(int buttonNum) {
    toggleAction([playerNum, buttonNum]);
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

    return Expanded(
      child: RotatedBox(
        quarterTurns: _getRotation(playerNum),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      toggleReady(-1);
                    },
                  ),
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        child: child,
                        scale: animation,
                      );
                    },
                    child: Text(
                      turnTracker.getPhaseText(),
                      key: ValueKey<String>(turnTracker.getPhaseText()),
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      toggleReady(-2);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Stack(
                    children: [

                      /// Big circular ready button
                      Center(
                        heightFactor: 1,
                        child: AnimatedReady(
                          isReady: turnTracker.isPlayerReady(playerNum),
                          shouldAnimateReady: turnTracker.shouldAnimatePlayerReady(playerNum),
                          buttonSize: screenSize.width*0.8,
                        ),
                      ),

                      /// Orange line above button row
                      Positioned(
                        bottom: screenSize.height*0.10,
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

                      /// Temporary ready button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            toggleReady(playerNum);
                          },
                          child: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get rotation value for each player.
  ///
  /// Used to rotate player 1 180 degrees.
  int _getRotation(playerNum) {
    if (playerNum == 1) return 2;
    else return 0;
  }

  /// Get color for a button based on its state.
  Color _getReadyButtonColor(context, playerNum) {
    if (turnTracker.checkReadiness(playerNum)) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Color(0xFF232323);
    }
  }
}
