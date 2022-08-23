import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';

import 'package:spirit_island_app/pages/game_view_animator.dart';
import 'package:spirit_island_app/pages/game_view_painter.dart';
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
    //Screen.keepOn(true);

    if (!_turnTracker.initDone) {
      _turnTracker.init(widget.game, widget.playerCount);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
  TextStyle _getActionButtonStyle(context, playerNum, buttonNum) {
    if (turnTracker.isActionAvailable(buttonNum)
        && turnTracker.isActionDone(playerNum, buttonNum)) {

      return Theme.of(context).textTheme.labelMedium
          .merge(GoogleFonts.alegreyaSansSc())
          .copyWith(color: Theme.of(context).colorScheme.primary);

    } else {
      return Theme.of(context).textTheme.labelSmall
          .merge(GoogleFonts.alegreyaSansSc())
          .copyWith(color: Theme.of(context).colorScheme.onBackground);
    }
  }


  /// Get style for a button depending on its state.
  List<TextStyle> _getActionButtonStyles(context, actionButtonCount, playerNum) {
    List<TextStyle> buttonStyles = [];

    for (int i=0; i<actionButtonCount; i++) {
      if (turnTracker.isActionAvailable(i)) {
        if (turnTracker.isActionDone(playerNum, i)) {
          buttonStyles.add(Theme.of(context).textTheme.labelMedium
          .merge(GoogleFonts.alegreyaSansSc())
          .copyWith(color: Theme.of(context).colorScheme.primary));
        } else {
          buttonStyles.add(Theme.of(context).textTheme.labelSmall
              .merge(GoogleFonts.alegreyaSansSc())
              .copyWith(color: Theme.of(context).colorScheme.onBackground));
        }
      }
    }
    return buttonStyles;
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final actionText = turnTracker.getActionText();
    final actionButtonCount = turnTracker.getNumberOfActions();

    // Expanded RotatedBox Container Column of
    //    Row of [IconButton, Container AnimatedSwitcher Text, IconButton]
    //    Expanded Container Stack of
    //        Center GestureDetector AnimatedReady
    //        Positioned Row of [ActionButton, ActionButton, ActionButton]

    // Expanded RotatedBox Container Column of
    //    Row of [IconButton, Container AnimatedSwitcher Text, IconButton]
    //    Row of [Timer]
    //    Expanded Container Stack of
    //        Center AnimatedReady
    //        Positioned Shape
    //        Center RoundedButton
    //        Positioned ButtonBar


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
                          .merge(GoogleFonts.alegreyaSansSc()),
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
                          buttonSize: size.width*0.8,
                        ),
                      ),

                      /// Orange line above button row
                      Positioned(
                        bottom: size.height*0.10,
                        left: 0,
                        height: 6,
                        width: size.width,
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



                      /*
                      Positioned(
                        bottom: 0,
                        left: 0,
                        height: size.height*0.13,
                        width: size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (turnTracker.isActionAvailable(0))
                                ActionButton(
                                  turnTracker: turnTracker,
                                  playerNum: playerNum,
                                  actionNum: 0,
                                  actionText: actionText[0],
                                  toggleAction: toggleAction,
                                  numberOfActions: turnTracker.getNumberOfActions(),
                                ),
                              if (turnTracker.isActionAvailable(1))
                                ActionButton(
                                  turnTracker: turnTracker,
                                  playerNum: playerNum,
                                  actionNum: 1,
                                  actionText: actionText[1],
                                  toggleAction: toggleAction,
                                  numberOfActions: turnTracker.getNumberOfActions(),
                                ),
                              if (turnTracker.isActionAvailable(2))
                                ActionButton(
                                  turnTracker: turnTracker,
                                  playerNum: playerNum,
                                  actionNum: 2,
                                  actionText: actionText[2],
                                  toggleAction: toggleAction,
                                  numberOfActions: turnTracker.getNumberOfActions(),
                                ),
                            ],
                          ),
                      ),
                      */
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


/// An action button.
class ActionButton extends StatelessWidget {
  ActionButton({this.turnTracker, this.playerNum, this.actionNum,
    this.actionText, @required this.toggleAction, this.numberOfActions});
  final turnTracker;
  final int playerNum;
  final int actionNum;
  final String actionText;
  final ValueChanged<List<int>> toggleAction;
  final int numberOfActions;

  @override
  Widget build(BuildContext context) {
    final color = _getActionButtonColor(context, playerNum, actionNum);
    final style = _getActionButtonStyle(context, playerNum, actionNum);
    final Size size = MediaQuery.of(context).size;
    double buttonWidth = size.width/numberOfActions;

    // Custom shape and a button in a stack.
    return Stack(
      children: [
        CustomPaint(
          size: Size(buttonWidth, size.height*(1/5)),
          painter: ButtonCustomPainter(Theme.of(context).colorScheme.tertiary, playerNum, actionNum, numberOfActions),
        ),
        GestureDetector(
          onTap: () {
            toggleAction([playerNum, actionNum]);
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            color: Theme.of(context).colorScheme.tertiary,
            alignment: Alignment.center,
            width: buttonWidth,
            child: Text(
              actionText,
              style: style,
            ),
          ),
        ),
      ],
    );

    /*
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            toggleAction([playerNum, actionNum]);
            },
          child: Stack(
            children: [
              CustomPaint(
                size: Size(buttonWidth, size.height*(1/5)),
                painter: ButtonCustomPainter(color, playerNum, actionNum, numberOfActions),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: size.height*0.03),
                width: buttonWidth,
                child: Text(
                  actionText,
                  style: Theme.of(context).textTheme.bodyText2
                      .merge(GoogleFonts.alegreyaSansSc())
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
     */
  }

  /// Get style for a button text based on its state.
  TextStyle _getActionButtonStyle(context, playerNum, actionNum) {
    if (turnTracker.isActionAvailable(actionNum)
        && turnTracker.isActionDone(playerNum, actionNum)) {

      return Theme.of(context).textTheme.labelMedium
          .merge(GoogleFonts.alegreyaSansSc());

    } else {
      return Theme.of(context).textTheme.labelSmall
          .merge(GoogleFonts.alegreyaSansSc());
    }
  }

  /// Get color for a button text based on its state.
  Color _getActionButtonColor(context, playerNum, actionNum) {
    if (turnTracker.isActionAvailable(actionNum)) {
      if (turnTracker.isActionDone(playerNum, actionNum)) {
        return Theme.of(context).colorScheme.secondary;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    } else {
      return Theme.of(context).colorScheme.tertiary;
    }
  }
}