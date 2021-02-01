import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/screen.dart';

import 'package:spirit_island_app/pages/game_view_animator.dart';
import 'package:spirit_island_app/pages/game_view_painter.dart';
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
    Screen.keepOn(true);

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
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    // Disable full screen.
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final actionText = turnTracker.getActionText();

    return Expanded(
      child: RotatedBox(
        quarterTurns: _getRotation(playerNum),
        child: Container(
          margin: EdgeInsets.only(bottom: _getMargin(playerNum)),
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
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
                        style: Theme.of(context).textTheme.headline4
                            .merge(GoogleFonts.alegreyaSansSc()),
                      ),
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
                      Center(
                        heightFactor: 1.8,
                        child: AnimatedBg(
                          isReady: turnTracker.isPlayerReady(playerNum),
                          shouldAnimateReady: turnTracker.shouldAnimatePlayerReady(playerNum),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        height: 200,
                        width: size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ActionButton(
                                turnTracker: turnTracker,
                                playerNum: playerNum,
                                actionNum: 0,
                                actionText: actionText[0],
                                toggleAction: toggleAction,
                              ),
                              ActionButton(
                                turnTracker: turnTracker,
                                playerNum: playerNum,
                                actionNum: 1,
                                actionText: actionText[1],
                                toggleAction: toggleAction,
                              ),
                              ActionButton(
                                turnTracker: turnTracker,
                                playerNum: playerNum,
                                actionNum: 2,
                                actionText: actionText[2],
                                toggleAction: toggleAction,
                              ),
                            ],
                          ),
                      ),
                      Center(
                        heightFactor: 1.8,
                        child: GestureDetector(
                          onTap: () {
                            toggleReady(playerNum);
                          },
                          child: AnimatedReady(
                            isReady: turnTracker.isPlayerReady(playerNum),
                            shouldAnimateReady: turnTracker.shouldAnimatePlayerReady(playerNum),
                          ),
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

  /// Get padding value for each player.
  ///
  /// Used to avoid camera notch for player 1.
  double _getMargin(playerNum) {
    if (playerNum == 1) return 0;
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
  ActionButton({this.turnTracker, this.playerNum, this.actionNum, this.actionText, @required this.toggleAction});
  final turnTracker;
  final playerNum;
  final actionNum;
  final actionText;
  final ValueChanged<List<int>> toggleAction;

  @override
  Widget build(BuildContext context) {
    final color = _getActionButtonColor(context, playerNum, actionNum);

    final Size size = MediaQuery.of(context).size;
    double width = size.width;
    if (actionNum == 1) width = width*0.40;
    else width = width*0.30;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            toggleAction([playerNum, actionNum]);
            },
          child: Stack(
            children: [
              CustomPaint(
                size: Size(width, 200),
                painter: ButtonCustomPainter(color, playerNum, actionNum),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 35),
                width: width,
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
  }

  /// Get color for a button based on its state.
  Color _getActionButtonColor(context, playerNum, actionNum) {
    if (turnTracker.isActionAvailable(actionNum)) {
      if (turnTracker.isActionDone(playerNum, actionNum)) {
        return Theme.of(context).colorScheme.secondary;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }
}